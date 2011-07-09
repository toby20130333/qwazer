import QtQuick 1.0

Rectangle {
    id: toolBar
    width: parent.width
    height: Math.max(backButtonPriv.height, itemsListView.height)
    color: "#c4c4c4"

    signal backButtonClicked

    property alias backButton : backButtonPriv

    Button {
        id: backButtonPriv
        text: translator.translate("Back") + mainView.forceTranslate
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        onClicked: backButtonClicked()
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
