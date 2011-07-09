import QtQuick 1.0

Rectangle {
    id: pageStack
    anchors.fill: parent

    function moveToNextPage(nextState) {
        pagesView.incrementCurrentIndex();
        pagesView.currentItem.state = nextState;
    }

    function moveToPrevPage(prevState) {
        pagesView.decrementCurrentIndex();
        pagesView.currentItem.state = prevState;
    }

    property VisualItemModel pages : VisualItemModel {}

    ListView {
        id: pagesView
        anchors.fill: parent
        model: pages
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        boundsBehavior: Flickable.StopAtBounds
        preferredHighlightBegin: 0
        preferredHighlightEnd: pageStack.width
        highlightRangeMode: ListView.StrictlyEnforceRange
        flickableDirection: Flickable.VerticalFlick
    }
}