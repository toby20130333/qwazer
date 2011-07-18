import QtQuick 1.0
import com.meego 1.0

Page {
    id: settingsPage

    tools: commonBackButtonToolbar

    Grid {
        columns: 2
        spacing: 20

        Label {
            text: translator.translate("Fullscreen instructions%1", ":") + translator.forceTranslate
        }

        Switch {

        }

        Label {
            text: translator.translate("North Locked%1", ":") + translator.forceTranslate
        }

        Switch {

        }

        Label {
            text: translator.translate("Show Next Turns%1", ":") + translator.forceTranslate
        }

        Switch {

        }
    }
}
