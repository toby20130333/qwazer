import QtQuick 1.0
import com.meego 1.0
import "../qwazer/js/Images.js" as Images

Page {
    id: settingsPage

    tools: ToolBarLayout {
        ButtonRow {
            anchors.right: parent.right
            anchors.left: backButton.right
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            Button {
                id: generalStateButton
                text: translator.translate("General") + translator.forceTranslate
            }

            Button {
                id: navigationStateButton
                text: translator.translate("Navigation") + translator.forceTranslate
            }
        }

        ToolIcon {
            id: backButton;
            anchors.verticalCenterOffset: 0;
            anchors.leftMargin: 10;
            iconId: "toolbar-back"
            anchors.left: parent===undefined ? undefined : parent.left
            onClicked: {
               if (settings.isFirstRun)
               {
                   settings.isFirstRun = !settings.isFirstRun;
                   mainPage.initialize();
               }
               else
               {
                   appWindow.pageStack.pop();
               }
            }
        }
    }

    Column {
        id: settingsColumn
        spacing: 30
        anchors.fill: parent
        anchors.margins: 30

        Label {
            id: generalSettingsLabel
            text: translator.translate("General application settings%1", ":") + translator.forceTranslate
            font.underline: true
        }

        Grid {
            id: generalSettingsGrid
            columns: 2
            spacing: 20

            Label {
                text: translator.translate("Language%1", ":") + translator.forceTranslate
            }

            Button {
                text: settings.language.name
                onClicked: languagesMenu.open()
                width: 200
            }

            Label {
                text: translator.translate("Default Country%1", ":") + translator.forceTranslate
            }

            Button {
                text: settings.country.name
                onClicked: countriesMenu.open()
                width: 200
            }

            Label {
                text: translator.translate("Night Mode (TODO)%1", ":") + translator.forceTranslate
            }

            Switch {
                checked: settings.nightMode
                onCheckedChanged: settings.nightMode = checked
            }
        }

        Label {
            id: navigationSettingsLabel
            text: translator.translate("Navigation Settings%1", ":") + translator.forceTranslate
            font.underline: true
        }

        Grid {
            id: navigationSettingsGrid
            columns: 2
            spacing: 20

            Label {
                text: translator.translate("Fullscreen instructions%1", ":") + translator.forceTranslate
            }

            Switch {
                checked: settings.navigationFullscreenInstruction
                onCheckedChanged: settings.navigationFullscreenInstruction = checked
            }

            Label {
                text: translator.translate("North Locked%1", ":") + translator.forceTranslate
            }

            Switch {
                checked: settings.navigationNorthLocked
                onCheckedChanged: settings.navigationNorthLocked = checked
            }

            Label {
                text: translator.translate("Show Next Turns%1", ":") + translator.forceTranslate
            }

            Switch {
                checked: settings.navigationShowNextTurns
                onCheckedChanged: settings.navigationShowNextTurns = checked
            }

            Label {
                text: translator.translate("Screen stays lit%1", ":") + translator.forceTranslate
            }

            Switch {
                checked: settings.navigationScreenStaysLit
                onCheckedChanged: settings.navigationScreenStaysLit = checked
            }
        }
    }

    Menu {
        id: languagesMenu

        content: MenuLayout {
            MenuItem {
                text: "English"
                onClicked: settings.languageName = text
            }
            MenuItem {
                text: "עברית"
                onClicked: settings.languageName = text
            }
        }
    }

    Menu {
        id: countriesMenu

        content: MenuLayout {
            MenuItem {
                text: "World"
                onClicked: settings.countryName = text
            }
            MenuItem {
                text: "Israel"
                onClicked: settings.countryName = text
            }
        }
    }

    states: [
        State {
            name: "General"
            when: generalStateButton.checked
            PropertyChanges {
                target: generalSettingsLabel
                visible: true
            }
            PropertyChanges {
                target: generalSettingsGrid
                visible: true
            }
            PropertyChanges {
                target: navigationSettingsLabel
                visible: false
            }
            PropertyChanges {
                target: navigationSettingsGrid
                visible: false
            }
        },
        State {
            name: "Navigation"
            when: navigationStateButton.checked
            PropertyChanges {
                target: generalSettingsLabel
                visible: false
            }
            PropertyChanges {
                target: generalSettingsGrid
                visible: false
            }
            PropertyChanges {
                target: navigationSettingsLabel
                visible: true
            }
            PropertyChanges {
                target: navigationSettingsGrid
                visible: true
            }
        }
    ]
}
