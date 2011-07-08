import QtQuick 1.0

Rectangle {
    id: page
    border.color: "#000000"

    property string title
    onTitleChanged: titlePriv.title = title

    property alias toolbar: toolbarPriv
    property alias titlebar: titlePriv
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
        y: 353
        anchors.bottomMargin: 0
        anchors.right: page.right
        anchors.left: page.left
        anchors.bottom: page.bottom

        onBackButtonClicked: moveToPrevPage("")
    }
}
