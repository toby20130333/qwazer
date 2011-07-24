import QtQuick 1.0

Rectangle {
    id: navSettings
    width: 800
    height: 400
    anchors.fill: parent

    signal backButtonClicked

    Flow {
        id: toolbarNavSettingsRow
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        Button {
            text: translator.translate("Back") + translator.forceTranslate
            onClicked: navSettings.backButtonClicked()
        }
    }

    Grid {
        id: grid1
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.top: toolbarNavSettingsRow.bottom
        anchors.topMargin: 20
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
