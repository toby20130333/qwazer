import QtQuick 1.0

Item {

    property bool isGPSDataValid :  gpsData.position.verticalAccuracyValid &&
                                    gpsData.position.horizontalAccuracyValid &&
                                    gpsData.position.verticalAccuracy < 100 &&
                                    gpsData.position.horizontalAccuracy < 100
    states: [
        State {
            name: "Browse"
            PropertyChanges {
                target: settingsButton
                onClicked: mainView.state = "SettingsState";
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
                target: map
                mapRotates: false
            }
            PropertyChanges {
                target: gpsData
                onPositionChanged: map.showMe()
            }
            PropertyChanges {
                target: currentInstruction
                visible: false
            }
        },
        State {
            name: "Navigation"
            PropertyChanges {
                target: settingsButton
                onClicked: appWindow.pageStack.push(navSettingsPage)
            }
            PropertyChanges {
                target: map
                mapRotates: true
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
                target: currentInstruction
                visible: true
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
