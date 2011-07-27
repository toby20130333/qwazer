import QtQuick 1.0

Rectangle {
    id: toolbar
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    height: tools.height

    property VisualItemModel toolBarItems

    Rectangle {
        id: shadow
        height: 5
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ffffff"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        opacity: 0.3
        anchors.bottom: parent.top
    }

    Rectangle {
        id: tools
        height: visualItems.height
        anchors.fill: parent
        color: "#848484"
        ListView {
            id: visualItems
            height: 63
            model: toolBarItems
        }
    }
}
