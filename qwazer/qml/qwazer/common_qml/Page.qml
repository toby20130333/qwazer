import QtQuick 1.0

Rectangle {
    id: page
    border.color: "#000000"

    property string title
    onTitleChanged: titlePriv.title = title

    property alias toolbarLeftItems: toolbarPriv.leftItems
    property alias toolbarMiddleItems: toolbarPriv.middleItems
    property alias toolbarRightItems: toolbarPriv.rightItems
    property alias titlebarItems: titlePriv.items
    property alias content: contentPlaceholderPriv

    signal moveToNextPage(string nextState)
    signal moveToPrevPage(string prevState)

    TitleBar {
        id: titlePriv
        anchors.top: page.top
        anchors.right: page.right
        anchors.left: page.left
    }

    Rectangle {
        id: contentPlaceholderPriv

        anchors.top: titlePriv.bottom
        anchors.bottom: toolbarPriv.top
        anchors.right: page.right
        anchors.left: page.left
    }

    ToolBar {
        id: toolbarPriv
        anchors.right: page.right
        anchors.left: page.left
        anchors.bottom: page.bottom

        onBackButtonClicked: moveToPrevPage("")
    }
}
