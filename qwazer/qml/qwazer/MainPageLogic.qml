import QtQuick 1.0

Item {

    property bool isGPSDataValid :  gpsData.position.verticalAccuracyValid &&
                                    gpsData.position.horizontalAccuracyValid &&
                                    gpsData.position.verticalAccuracy < 100 &&
                                    gpsData.position.horizontalAccuracy < 100

    signal showNavigationSettings
    signal showApplicationSettings

    states: [
        State {
            name: "Browse"
            PropertyChanges {
                target: settingsButton
                onClicked: showApplicationSettings()
            }
            PropertyChanges {
                target: stopNavigationButton
                visible: false
            }
            PropertyChanges {
                target: searchButton
                visible: true
            }
            PropertyChanges {
                target: gpsData
                onPositionChanged: map.showMe()
            }
        },
        State {
            name: "Navigation"
            PropertyChanges {
                target: settingsButton
                onClicked: showNavigationSettings()
            }
            PropertyChanges {
                target: stopNavigationButton
                visible: true
            }
            PropertyChanges {
                target: searchButton
                visible: false
            }
            PropertyChanges {
                target: followMeButton
                isSelected: true
            }
            PropertyChanges {
                target: gpsData
                onPositionChanged: map.syncLocation()
            }
        }
    ]
}
