import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

HOOK = Path(__file__).resolve().parents[1] / 'hooks/post-update.d/update-menu-clone.hook'


class MenuCloneUpdateTest(unittest.TestCase):
    def test_only_stock_changes_replace_customizations(self):
        with tempfile.TemporaryDirectory() as tmp:
            base = Path(tmp)
            clone = base / 'home/.config/omarchy/plugins/smartins.menu'
            source = base / 'stock/shell/plugins/menu'
            clone.mkdir(parents=True)
            source.mkdir(parents=True)
            custom = clone / 'Menu.qml'
            custom.write_text('custom menu')
            manifest = source / 'manifest.json'
            manifest.write_text(json.dumps({
                'id': 'omarchy.menu', 'name': 'Omarchy menu', 'version': '2',
                'barWidget': {'displayName': 'Omarchy menu'},
            }))
            stock_menu = source / 'Menu.qml'
            stock_menu.write_text('stock menu')
            env = dict(os.environ, HOME=str(base / 'home'),
                       XDG_STATE_HOME=str(base / 'state'), OMARCHY_PATH=str(base / 'stock'))

            def run(ok=True):
                result = subprocess.run(['bash', str(HOOK)], env=env, capture_output=True, text=True)
                self.assertEqual(result.returncode == 0, ok, result.stderr)

            state = base / 'state/omarchy/menu-clone-stock.sha256'
            run()  # First run records the baseline without erasing customization.
            baseline = state.read_text()
            run()
            stock_menu.touch()
            run()  # Timestamps alone do not count as a stock change.
            self.assertEqual(custom.read_text(), 'custom menu')
            self.assertEqual(state.read_text(), baseline)
            stock_menu.write_text('updated stock menu')
            run()
            self.assertEqual(custom.read_text(), 'updated stock menu')
            self.assertEqual(json.loads((clone / 'manifest.json').read_text())['id'], 'smartins.menu')
            self.assertNotEqual(state.read_text(), baseline)
            custom.write_text('reapplied customization')
            run()
            self.assertEqual(custom.read_text(), 'reapplied customization')
            (source / 'new.qml').write_text('new stock file')
            run()
            self.assertTrue((clone / 'new.qml').exists())
            (source / 'new.qml').unlink()
            run()
            self.assertFalse((clone / 'new.qml').exists())
            last_good = state.read_text()
            custom.write_text('keep on failure')
            manifest.write_text('invalid JSON')
            run(ok=False)
            self.assertEqual(custom.read_text(), 'keep on failure')
            self.assertEqual(state.read_text(), last_good)


if __name__ == '__main__':
    unittest.main()
