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
        anchors.topMargin: -13

        MapView {
            id: qwazerMapView

            anchors.fill: content

            visible: false

            onMapLoaded: {
                mainView.state = 'MapState';
            }

            onSearchButtonClicked: {
                mainView.state = 'SearchState';
            }

            onSettingsButtonClicked: mainView.state = "SettingsState"
        }

        Search {
            id: search1
            visible: false
            anchors.fill: content

            onBackButtonClicked: {
                mainView.state = 'MapState';
            }
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
            anchors.fill: content
            visible: false
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
            }
            PropertyChanges {
                 target: search1
                 visible: false
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
            name: "SearchState"

            PropertyChanges {
                target: qwazerMapView
                visible: false
            }
            PropertyChanges {
                target: search1
                visible: true
                state: "Search"
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
                target: search1
                visible: false
            }
            PropertyChanges {
                target: settingsPage
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
                target: search1
                visible: false
            }
            PropertyChanges {
                target: settingsPage
                visible: false
            }
            PropertyChanges {
                target: navSettings
                visible: true
            }
        }
    ]
}
