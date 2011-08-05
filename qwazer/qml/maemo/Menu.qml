import QtQuick 1.0

Rectangle {
    id: menu
    color: "#00000000"
    anchors.fill: parent

    property VisualItemModel menuItems

    signal backButtonClicked

    Rectangle {
        id: shade
        color: "#000000"
        opacity: 0.7
        anchors.fill: parent
        MouseArea {
            id: mouse_area1
            anchors.fill: parent
            onClicked: menu.backButtonClicked()
        }
    }

    Rectangle {
        id: menuItemsPriv
        x: 32
        width: parent.width/2
        radius: 10
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top

        ListView {
            id: visualItems
            anchors.fill: parent
            anchors.margins: 10
            snapMode: ListView.SnapOneItem
            preferredHighlightBegin: 0; preferredHighlightEnd: 0
            highlightRangeMode: ListView.StrictlyEnforceRange
            model: menuItems
        }
    }
}
