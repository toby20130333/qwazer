import QtQuick 1.0
import "../qwazer"

Rectangle {
    id: mainPage
    width: 800
    height: 400

    signal mapLoaded
    signal searchButtonClicked
    signal settingsButtonClicked

    function initialize()
    {
        map.initialize();
    }

    function showLocation(lon, lat) {
        map.showLocation(lon, lat);
    }

    function navigate(course) {
        mainView.state = "MapState";
        map.navigationInfo = course;
        mainPageLogic.state = "Navigation";
    }

    function stopNavigation() {
        map.stopNavigation();
        mainPageLogic.state = "Browse";
    }

    QwazerMap {
        id: map

        anchors.fill: mainPage

        isFollowMe: followMeButton.isSelected
        onMapLoaded: mainPage.mapLoaded()

        Column {
            id: zoomButtons
            anchors.right: map.right
            anchors.rightMargin: 10
            anchors.verticalCenter: map.verticalCenter
            spacing: 50
            width: 50

            Button {
                text: "+"
                width: height
                radius: height
                onClicked: map.zoomIn()
            }

            Button {
                text: "-"
                width: height
                radius: height
                onClicked: map.zoomOut()
            }
        }

        Flow {
            anchors.right: map.right
            anchors.rightMargin: spacing
            anchors.left: map.left
            anchors.leftMargin: spacing
            anchors.top: map.top
            spacing: 20

            Button {
                id: searchButton
                text: "Search"
                onClicked: searchButtonClicked()
            }

            Button {
                id: settingsButton
                text: "Settings"
                onClicked: settingsButtonClicked()
            }

            Button {
                id: stopNavigationButton;
                text: "Stop"
                onClicked: mainPage.stopNavigation()
            }
            Button {
                id: followMeButton;
                onClicked: followMeButton.isSelected = !followMeButton.isSelected
                text: "Locked"
                property bool isSelected: false

                states: [
                    State {
                        name: "Selected"
                        when:  followMeButton.isSelected

                        PropertyChanges {
                            target: followMeButton
                            text: "Unlocked"
                        }
                    },
                    State {
                        name: "UnSelected"
                        when:  !followMeButton.isSelected

                        PropertyChanges {
                            target: followMeButton
                            text: "Locked"
                        }
                    }
                ]
            }
        }
    }

    InstructionsControl {
        id: currentInstruction
        visible: false
        anchors.bottom: mainPage.bottom
        anchors.bottomMargin: 10
        anchors.left: mainPage.left
        opacity: 0.7
    }

    MainPageLogic {
        id: mainPageLogic
        state:  "Browse"
        onShowApplicationSettings: mainView.state = "SettingsState"
        onShowNavigationSettings: mainView.state = "NavSettingsState"
    }
}
