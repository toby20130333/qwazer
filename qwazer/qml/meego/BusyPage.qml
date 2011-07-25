import QtQuick 1.0
import com.meego 1.0
import "../qwazer/js/Images.js" as Images

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

            text: translator.translate("Loading%1", "...") + translator.forceTranslate
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
            iconSource: Images.back
            onClicked: backClicked();
        }
    }
}
