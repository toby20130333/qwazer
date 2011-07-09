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

    Rectangle {
        color: "#00000000"
        anchors.left: toolBar.left
        anchors.leftMargin: 10
        width: leftItemsListView.contentWidth

        ListView {
            id: leftItemsListView
            model: leftItems
            orientation: ListView.Horizontal
            boundsBehavior: Flickable.StopAtBounds
        }
    }

    Rectangle {
        color: "#00000000"
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.horizontalCenter: toolBar.horizontalCenter
        width: middelItemsListView.contentWidth
        ListView {
            id: middelItemsListView
            model: middleItems
            orientation: ListView.Horizontal
            boundsBehavior: Flickable.StopAtBounds
        }
    }

    Rectangle {
        color: "#00000000"
        anchors.right: toolBar.right
        anchors.rightMargin: width + 10
        width: rightItemsListView.contentWidth

        ListView {
            id: rightItemsListView
            model: rightItems
            orientation: ListView.Horizontal
            boundsBehavior: Flickable.StopAtBounds
        }
    }
}
