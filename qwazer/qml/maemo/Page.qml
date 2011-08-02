import QtQuick 1.0

Rectangle {
    id: page
    anchors.fill: parent

    property VisualItemModel tools
    property VisualItemModel content
    property alias container : contentPriv
    visible: false

    Rectangle {
        id: contentPriv
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: toolBar.top
        anchors.top: parent.top

        ListView {
            anchors.fill: contentPriv
            snapMode: ListView.SnapOneItem
            preferredHighlightBegin: 0; preferredHighlightEnd: 0
            highlightRangeMode: ListView.StrictlyEnforceRange
            orientation: ListView.Horizontal
            interactive: false
            model: content
        }
    }

    ToolBar {
        id: toolBar
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        toolBarItems: tools
    }
}
