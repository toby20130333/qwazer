import QtQuick 1.0
import "../common_qml"

Page {
    id: navigationSettings

    title: translator.translate("Navigation Settings") + mainView.forceTranslate

    Grid {
        anchors.fill: navigationSettings.content
        spacing: 10
        columns: 2

        Text {
            text: translator.translate("Fullscreen instructions%1", ":")
        }

        YesNoSelectorButton {

        }

        Text {
            text: translator.translate("North Locked%1", ":")
        }

        YesNoSelectorButton {

        }

        Text {
            text: translator.translate("Show Next Turns%1", ":")
        }

        YesNoSelectorButton {

        }

        Text {
            text: translator.translate("Follow Me%1", ":")
            scale: 0.1
        }

        YesNoSelectorButton {

        }
    }

}
