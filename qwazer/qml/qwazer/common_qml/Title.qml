import QtQuick 1.0

Rectangle {
    id: titleBar
    width: parent.width
    height: titleLabel.height
    color: "#c4c4c4"

    property string title
    onTitleChanged: titleLabel.text = title

    Text {
        id: titleLabel
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        font.bold: true
        font.pointSize: 18

    }
}
