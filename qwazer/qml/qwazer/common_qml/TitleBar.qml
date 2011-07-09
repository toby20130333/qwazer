import QtQuick 1.0

Rectangle {
    id: titleBar
    width: parent.width
    height: 50
    color: "#c4c4c4"

    property string title
    onTitleChanged: titleLabel.text = title

    Text {
        id: titleLabel
        verticalAlignment: Text.AlignVCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        font.bold: true
        font.pointSize: 18

    }

    property VisualItemModel middleItems : VisualItemModel {}

    Rectangle {
        color: "#00000000"
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.horizontalCenter: titleBar.horizontalCenter
        width: middelItemsListView.contentWidth
        ListView {
            id: middelItemsListView
            model: middleItems
            orientation: ListView.Horizontal
            boundsBehavior: Flickable.StopAtBounds
        }
    }
}
