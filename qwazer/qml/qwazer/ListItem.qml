import QtQuick 1.0

Rectangle {
    id: listItem
    border.color: "black"
    border.width: 2
    radius: 10

    signal clicked

    property string text

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: "gray"
        }
        GradientStop {
            position: 1.0
            color: "lightGray"
        }
    }

    height: rowText.height * 2

    Text {
        id: rowText
        text: listItem.text
        font.bold: true
        font.pointSize: 24
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MouseArea {
        anchors.fill: parent
        onClicked: listItem.clicked()
    }
}
