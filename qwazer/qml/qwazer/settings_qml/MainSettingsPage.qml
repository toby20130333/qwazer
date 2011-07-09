import QtQuick 1.0
import "../common_qml"

Page {
    id: mainSettingsPage

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
            text:  qwazerSettings.language.name
            onClicked: mainSettingsPage.moveToNextPage("LanguageSelectionState");
        }

        Text {
            id: countryLabel
            text: translator.translate("Default Country%1", ":") + mainView.forceTranslate
            font.pointSize: 20
        }

        Button {
            id: selectedCountry
            text:  qwazerSettings.country.name
            onClicked: mainSettingsPage.moveToNextPage("CountrySelectionState");
        }

        Text {
            id: nightModeLabel
            text: translator.translate("Night Mode (TODO)%1", ":") + mainView.forceTranslate
            font.pointSize: 20
        }

        DualStateButton {
            id: nightModeSelector
            leftText: translator.translate("Yes") + mainView.forceTranslate
            rightText: translator.translate("No") + mainView.forceTranslate
            selectedIndex: qwazerSettings.nightMode? 0 : 1
            onSelectedIndexChanged: qwazerSettings.nightMode = (selectedIndex == 0);
        }
    }
}
