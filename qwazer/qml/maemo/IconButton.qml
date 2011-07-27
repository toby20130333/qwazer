import QtQuick 1.0

Rectangle {
    id: iconButton
    width: Math.max(iconImage.sourceSize.width, iconText.width)
    height: iconImage.sourceSize.height + iconText.paintedHeight
    color: "#00000000"

    signal clicked

    property string text
    property string iconSource

    Image {
        id: iconImage
        width: sourceSize.width
        height: sourceSize.height
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        source: iconButton.iconSource
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: iconText
        text: iconButton.text
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: iconImage.bottom
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        anchors.fill: iconButton
        onClicked: iconButton.clicked()
    }
}
