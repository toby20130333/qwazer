import QtQuick 1.0

Rectangle {
    id: toolbar
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    height: tools.height
    color: "#00000000"

    property VisualItemModel toolBarItems

    Rectangle {
        id: shadow
        y: toolbar.y-height
        height: 5
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#ffffff";
            }
            GradientStop {
                position: 1.00;
                color: "#000000";
            }
        }
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        opacity: 0.3
        anchors.bottom: tools.top
    }

    Rectangle {
        id: tools
        height: visualItems.height
        anchors.right: toolbar.right
        anchors.left: toolbar.left
        anchors.bottom: parent.bottom
        color: "#848484"
        ListView {
            id: visualItems
            height: 75
            snapMode: ListView.SnapOneItem
            preferredHighlightBegin: 0; preferredHighlightEnd: 0
            highlightRangeMode: ListView.StrictlyEnforceRange
            orientation: ListView.Horizontal
            model: toolBarItems
        }
    }
}
