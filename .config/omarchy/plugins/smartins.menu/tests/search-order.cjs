const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const path = require('node:path');
const base = path.join(__dirname, '..');
const model = require(path.join(base, 'MenuModel.js'));
const qml = fs.readFileSync(path.join(base, 'Menu.qml'), 'utf8');
assert(qml.includes('AppLibrary { id: menuAppLibrary }'));
assert(qml.includes('readonly property var appLibrary: menuAppLibrary'));
const start = qml.indexOf('  function rebuildDisplay() {');
const end = qml.indexOf('\n  // Contain alone', start);
assert(start >= 0 && end > start);
const items = Object.fromEntries([
  ['root', {label: 'Root'}],
  ['system', {label: 'System'}],
  ['apps', {label: 'Apps', provider: 'apps'}],
  ['system.restart', {label: 'Restart', action: 'restart'}],
].map(([id, value]) => [id, model.normalizeItem(id, value)]));
for (const [id, label] of [['apps.steam', 'Steam'], ['apps.steam-tools', 'Steam Tools']]) {
  items[id] = {...model.normalizeItem(id, {label}), kind: 'app'};
}
const order = Object.keys(items);
order.forEach((id, i) => items[id].order = i);
const displayModel = {
  rows: [], clear() {this.rows = [];}, append(row) {this.rows.push(row);},
  get count() {return this.rows.length;},
};
const root = {
  dmenuActive: false, rowsLoaded: true, activeMenu: 'root', filterText: 'ste', itemOrder: order,
  item: id => items[id],
  isDescendantOf: (id, parent) => model.isDescendantOf(items, id, parent),
  matchesQuery: (entry, query) => model.matchesQuery(entry, query, true),
  parentPathFor: id => model.parentPathFor(items, id),
  searchScore: (entry, query) => model.searchScore(items, entry, query),
  displayRow: (entry, detail, score) => model.displayRow(items, order, {}, entry, detail, score),
  isVisible: () => true,
};
const context = vm.createContext({root, displayModel, layoutSerial: 0, selectedIndex: 0, Qt: {callLater() {}}});
vm.runInContext(qml.slice(start, end), context);
function search(query, menu = 'root') {
  root.filterText = query; root.activeMenu = menu;
  context.rebuildDisplay();
  return displayModel.rows.map(row => row.itemId);
}
assert.deepEqual(search('ste'), ['apps.steam', 'apps.steam-tools', 'system']);
assert.deepEqual(search('system'), ['system']);
assert.deepEqual(search('missing'), []);
assert.deepEqual(search(''), ['system', 'apps']);
assert.deepEqual(search('ste', 'apps'), ['apps.steam', 'apps.steam-tools']);
assert.deepEqual(search('restart', 'system'), ['system.restart']);
console.log('Passed: apps first, menu-only matches, no matches, normal menu order, submenu search.');
