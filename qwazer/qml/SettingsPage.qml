import QtQuick 1.0
import com.meego 1.0

Page {
    id: settingsPage

    tools: ToolBarLayout {
        id: commonBackButtonToolbar
        ToolIcon { id: backButton; anchors.verticalCenterOffset: 0; anchors.leftMargin: 10; iconId: "toolbar-back"; platformIconId: "toolbar-back"
            anchors.left: parent===undefined ? undefined : parent.left
            onClicked: {
               if (settings.isFirstRun)
               {
                   settings.isFirstRun = !settings.isFirstRun;
                   appWindow.pageStack.replace(mainPage, null, true);
               }
               else
               {
                   appWindow.pageStack.pop();
               }
            }
        }
    }

    Grid {
        columns: 2
        spacing: 20

        Label {
            text: translator.translate("Language%1", ":") + translator.forceTranslate
        }

        Button {
            text: settings.language.name
            onClicked: languagesMenu.open()
        }

        Label {
            text: translator.translate("Default Country%1", ":") + translator.forceTranslate
        }

        Button {
            text: settings.country.name
            onClicked: countriesMenu.open()
        }

        Label {
            text: translator.translate("Night Mode (TODO)%1", ":") + translator.forceTranslate
        }

        Switch {
            checked: settings.nightMode
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
