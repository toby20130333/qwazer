import QtQuick 1.0

Rectangle {
    id: page
    anchors.fill: parent

    property VisualItemModel tools

    onVisibleChanged: {
        if (visible)
        {
            mainView.tools = page.tools;
        }
    }

}
