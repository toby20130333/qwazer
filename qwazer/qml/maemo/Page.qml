import QtQuick 1.0

Rectangle {
    id: page
    anchors.fill: parent

    property VisualItemModel tools
    property bool refreshTools
    onRefreshToolsChanged: mainView.tools = page.tools;
}
