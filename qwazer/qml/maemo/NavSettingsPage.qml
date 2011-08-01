import QtQuick 1.0
import "../qwazer/js/Images.js" as Images

Page {
    id: navSettings
    width: 800
    height: 400
    anchors.fill: parent

    signal backButtonClicked

    tools: VisualItemModel {
        Flow {
            id: toolbarNavSettingsRow
            anchors.margins: 20
            spacing: 20

            IconButton {
                iconSource: Images.back
                text: translator.translate("Back") + translator.forceTranslate
                onClicked: navSettings.backButtonClicked()
            }
        }
    }

    Grid {
        id: grid1
        anchors.right: parent.fill
        anchors.margins: 20
        anchors.left: parent.left
        columns: 2
        spacing: 20

        Text {
            text: translator.translate("Fullscreen instructions%1", ":") + translator.forceTranslate
        }

        ToggleButton {
            text: isSelected? "+" : "-"
        }

        Text {
            text: translator.translate("North Locked%1", ":") + translator.forceTranslate
        }

        ToggleButton {
            text: isSelected? "+" : "-"
        }

        Text {
            text: translator.translate("Show Next Turns%1", ":") + translator.forceTranslate
        }

        ToggleButton {
            text: isSelected? "+" : "-"
        }

        Text {
            text: translator.translate("Screen stays lit%1", ":") + translator.forceTranslate
        }

        ToggleButton {
            text: isSelected? "+" : "-"
        }
    }
}
