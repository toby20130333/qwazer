import QtQuick 1.0
import "../qwazer"

Rectangle {
    id: mainView
    width: 800
    height: 400

    property alias gpsData: gps.positionSource

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

    SettingsPage {
        id: settingsPage
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

    Translator { id: translator }

    MapView {
        id: qwazerMapView
        x: 0
        y: 0

        anchors.fill: parent

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
        x: 0
        y: 0
        visible: false
        anchors.fill: parent

        onBackButtonClicked: {
            mainView.state = 'MapState';
        }
    }

    NavSettingsPage {
        id: navSettings
        visible: false
        onBackButtonClicked: mainView.state = "MapState"
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
