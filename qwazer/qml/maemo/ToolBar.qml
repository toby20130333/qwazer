import QtQuick 1.0

Rectangle {
    id: toolbar
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.left: parent.left

    property alias toolBarItems: tools.children

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
        color: "#848484"
        anchors.topMargin: 0
        anchors.fill: parent
    }
}
