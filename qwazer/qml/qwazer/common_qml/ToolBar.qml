import QtQuick 1.0

Rectangle {
    id: toolBar
    width: parent.width
    height: 50
    color: "#c4c4c4"

    signal backButtonClicked

    property VisualItemModel leftItems: VisualItemModel { ToolBarBackButton {} }
    property VisualItemModel middleItems: VisualItemModel { }
    property VisualItemModel rightItems: VisualItemModel { }

    ListView {
        id: leftItemsListView
        anchors.left: toolBar.left
        anchors.leftMargin: 10
        model: leftItems
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
    }

    ListView {
        id: middelItemsListView
        anchors.right: rightItemsListView.left
        anchors.left: leftItemsListView.right
        model: middleItems
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
    }

    ListView {
        id: rightItemsListView
        anchors.right: toolBar.right
        anchors.rightMargin: 10
        model: rightItems
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
    }
}
