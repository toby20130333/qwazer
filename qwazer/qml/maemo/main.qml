import QtQuick 1.0
import "../qwazer"

Rectangle {
    id: mainView

    width: 800
    height: 400

    property alias gpsData: gps.positionSource
    property VisualItemModel tools

    Component.onCompleted: {
        settings.initialize();
    }

    GPSProvider {
        id: gps
    }

    QwazerSettings {
        id: settings

        onSettingsLoaded: {
            if (typeof(settings.isFirstRun) == "undefined" || settings.isFirstRun)
            {
                mainView.state = "SettingsState";
            }
            else
            {
                qwazerMapView.initialize();
            }
        }
    }

    Translator { id: translator }

    Rectangle {
        id: content
        anchors.right: mainView.right
        anchors.rightMargin: 0
        anchors.left: mainView.left
        anchors.leftMargin: 0
        anchors.bottom: toolBar.top
        anchors.bottomMargin: 0
        anchors.top: mainView.top
//        anchors.topMargin: -13

        BusyPage {
            id: settingsLoadPage
            visible: mainView.state == ""
            backIcon: ""
            onBackClicked: {}
        }

        MapView {
            id: qwazerMapView
            visible: false
            anchors.fill: content

            onMapLoaded: {
                mainView.state = 'MapState';
            }

            onSettingsButtonClicked: mainView.state = "SettingsState"
        }

        SettingsPage {
            id: settingsPage
            anchors.fill: content
            visible: false

            onOkClicked: {
                if (settings.isFirstRun)
                {
                    settings.isFirstRun = !settings.isFirstRun;
                    qwazerMapView.initialize();

                }
                else
                {
                    mainView.state = 'MapState';
                }
            }
        }

        NavSettingsPage {
            id: navSettings
            visible: false
            anchors.fill: content
            onBackButtonClicked: mainView.state = "MapState"
        }
    }


    ToolBar {
        id: toolBar
        toolBarItems: tools
        anchors.bottomMargin: -13
    }

    states: [
        State {
            name: "MapState"

            PropertyChanges {
                target: qwazerMapView
                visible: true
                refreshTools: eval("!qwazerMapView.refreshTools")
                state: "Map"
            }
            PropertyChanges {
                target: settingsPage
                visible: false
            }
            PropertyChanges {
                target: navSettings
                visible: false
            }
        },
        State {
            name: "SettingsState"

            PropertyChanges {
                target: qwazerMapView
                visible: false
            }
            PropertyChanges {
                target: settingsPage
                refreshTools: eval("!settingsPage.refreshTools")
                visible: true
            }
            PropertyChanges {
                target: navSettings
                visible: false
            }
        },
        State {
            name: "NavSettingsState"

            PropertyChanges {
                target: qwazerMapView
                visible: false
            }
            PropertyChanges {
                target: settingsPage
                visible: false
            }
            PropertyChanges {
                target: navSettings
                refreshTools: eval("!navSettings.refreshTools")
                visible: true
            }
        }
    ]
}
