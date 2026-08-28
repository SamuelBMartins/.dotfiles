import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "smartins.mirador-button"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰕰"
    tooltipText: "Workspace overview"
    horizontalMargin: 7.5
    onPressed: function(mouseButton) {
      if (!root.bar) return
      root.bar.run("omarchy-shell shell toggle mirador '{}'")
    }
  }
}
