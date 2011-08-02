import QtQuick 1.0
import "../qwazer"
import "../qwazer/js/Images.js" as Images

Page {
    id: busyPage

    width: 800
    height: 400

    anchors.fill: parent

    property alias text: loadStatus.text
    property alias backIcon: backButton.iconSource
    property alias backText: backButton.text

    signal backClicked

    Row {
        id: loadingIndicator
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        QwazerBusyIndicator {
            id: busyindicator1
            active: busyPage.visible
        }

        Text {
            id: loadStatus
            anchors.verticalCenter: busyindicator1.verticalCenter
            text: translator.translate("Loading%1", "...") + translator.forceTranslate
        }
    }

    tools: VisualItemModel {
        Flow {
            IconButton {
                id: backButton;
                text: translator.translate("Back") + translator.forceTranslate
                iconSource: Images.back
                onClicked: backClicked();
            }
        }
    }
}
