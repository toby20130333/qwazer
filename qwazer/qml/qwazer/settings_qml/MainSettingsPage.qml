import QtQuick 1.0
import "../common_qml"

Page {
    id: mainSettingsPage

    property alias countryName: selectedCountry.text
    property alias languageName: selectedLanguage.text
    property alias nightModeSelected: nightModeSelector.isSelected

    Grid {
        id: grid1
        anchors.fill: mainSettingsPage.content

        columns: 2
        spacing: 10

        Text {
            id: languageLabel
            text: translator.translate("Language%1", ":") + mainView.forceTranslate
            font.pointSize: 20
        }

        Button {
            id: selectedLanguage

            onClicked: mainSettingsPage.moveToNextPage("LanguageSelectionState");
        }

        Text {
            id: countryLabel
            text: translator.translate("Default Country%1", ":") + mainView.forceTranslate
            font.pointSize: 20
        }

        Button {
            id: selectedCountry

            onClicked: mainSettingsPage.moveToNextPage("CountrySelectionState");
        }

        Text {
            id: nightModeLabel
            text: translator.translate("Night Mode (TODO)%1", ":") + mainView.forceTranslate
            font.pointSize: 20
        }

        ToggleButton {
            id: nightModeSelector
            text: isSelected? "+" : "-"
        }
    }
}
