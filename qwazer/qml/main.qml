import QtQuick 1.0
import com.meego 1.0
//import QtMobility.location 1.1
import "qwazer"

PageStackWindow {
    id: appWindow

    initialPage: settingsLoadPage

    property alias gpsData: gps.positionSource

    GPSProvider {
        id: gps
    }

    QwazerSettings {
        id: settings

        onSettingsLoaded: mainPage.initialize()
    }

    Translator { id: translator }

    MainPage{id: mainPage}

    //SearchAddressPage {id: searchAddressPage}
    ToolBar {
        id: commonToolBar
        anchors.bottom: parent.bottom
    }

    MouseArea {
         anchors.fill: parent
         enabled: pageStack.busy
    }

    Page {
            id: settingsLoadPage
            anchors.fill: parent

            Component.onCompleted: {
                settings.initialize();
            }

            Row {
                id: loadingIndicator
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10

                BusyIndicator {
                    id: busyindicator1
                    width: 180
                    height: 30
                    running: true
                }

                Label {
                    id: loadStatus

                    text: "Loading..."
                }
            }

            tools: ToolBarLayout {
                id: commonTools
                visible: true

                ToolIcon {
                    id: quitButton;
                    y: 0;
                    width: 64;
                    anchors.right: parent.right;
                    anchors.rightMargin: 10;
                    anchors.verticalCenterOffset: 0;
                    iconId: "toolbar-close";
                    platformIconId: "toolbar-close"
                    onClicked: Qt.quit();
                }
            }
        }

    Page {
        id: settingsPage

        tools: ToolBarLayout {
            id: settingsToolBar
            visible: true

            ToolIcon {
                id: backButton;
                y: 0;
                width: 64;
                anchors.right: parent.right;
                anchors.rightMargin: 10;
                anchors.verticalCenterOffset: 0;
                iconId: "toolbar-back";
                platformIconId: "toolbar-back"
                onClicked: appWindow.pageStack.pop();
            }
        }

        Grid {
            columns: 2
            spacing: 20
            anchors.margins: 10

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
