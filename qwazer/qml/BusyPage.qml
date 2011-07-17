import QtQuick 1.0
import com.meego 1.0

Page {
    id: settingsLoadPage
    anchors.fill: parent

    property alias text: loadStatus.text
    property alias backIcon: backButton.iconId

    signal backClicked

    Row {
        id: loadingIndicator
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        BusyIndicator {
            id: busyindicator1
            running: true
        }

        Label {
            id: loadStatus

            text: "Loading..."
        }
    }

    tools: ToolBarLayout {
        id: commonTools
        visible: true

        ToolIcon {
            id: backButton;
            y: 0;
            width: 64;
            anchors.left: parent.left;
            anchors.leftMargin: 10;
            anchors.verticalCenterOffset: 0;
            iconId: "toolbar-back";
            platformIconId: iconId
            onClicked: backClicked();
        }
    }
}
