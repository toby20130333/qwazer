import QtQuick 1.0
import com.meego 1.0

Page {
    id: settingsPage

    tools: commonBackButtonToolbar

    Grid {
        columns: 2
        spacing: 20

        Label {
            text: "Language:"
        }

        Button {
            text: settings.language.name
            onClicked: languagesMenu.open()
        }

        Label {
            text: "Default Country:"
        }

        Button {
            text: settings.country.name
            onClicked: countriesMenu.open()
        }

        CheckBox {
            text: "Night Mode (TODO)"
            onCheckedChanged: settings.nightMode = checked
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
}
