import QtQuick 1.0
import com.meego 1.0

Page {
    id: selectedAddress

    tools: ToolBarLayout {

        ToolIcon {
            id: backButton;
            anchors.verticalCenterOffset: 0;
            anchors.leftMargin: 10;
            iconId: "toolbar-back";
            platformIconId: "toolbar-back"
            anchors.left: parent===undefined ? undefined : parent.left
            onClicked: appWindow.pageStack.pop()
        }

        ToolIcon {
            id: showButton;
            anchors.verticalCenterOffset: 0;
            anchors.rightMargin: 10;
            iconId: "toolbar-refresh";
            platformIconId: "toolbar-refresh"
            anchors.right: parent===undefined ? undefined : parent.right
            onClicked: appWindow.pageStack.pop()
        }

        ToolIcon {
            id: navigateButton;
            anchors.verticalCenterOffset: 0;
            anchors.rightMargin: 10;
            iconId: "toolbar-share";
            platformIconId: "toolbar-share"
            anchors.right: showButton.left
            onClicked: appWindow.pageStack.pop()
        }

        ToolIcon {
            id: addToFavoritesButton;
            anchors.verticalCenterOffset: 0;
            anchors.rightMargin: 10;
            iconId: "toolbar-add";
            platformIconId: "toolbar-add"
            anchors.right: navigateButton.left
            onClicked: appWindow.pageStack.pop()
        }
    }

    Grid {
        columns:2

        Label {
            text: "Address:"
        }

        Label {
            text: (selectedAddress.data===undefined || selectedAddress.data.name === undefined)? "" : selectedAddress.data.name
        }
    }
}
