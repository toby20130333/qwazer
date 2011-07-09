import QtQuick 1.0

Rectangle {
    id: titleBar
    width: parent.width
    height: Math.max(titleLabel.height, itemsListView.height);
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

    property VisualItemModel items : VisualItemModel {}

    ListView {
        id: itemsListView
        y: 0
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        model: items
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
    }
}
