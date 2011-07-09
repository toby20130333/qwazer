import QtQuick 1.0
import "common_qml"

Page {
    id: mapPage

    width: 800
    height: 400

    signal mapLoaded
    signal searchButtonClicked
    signal settingsButtonClicked

    property bool isGPSDataValid :  positionSource.position.verticalAccuracyValid &&
                                    positionSource.position.horizontalAccuracyValid &&
                                    positionSource.position.verticalAccuracy < 100 &&
                                    positionSource.position.horizontalAccuracy < 100



    function initialize() {
        map.initialize();
    }

    toolbarLeftItems: VisualItemModel {}

    toolbarMiddleItems: VisualItemModel {
        Flow {
            spacing: 10

            Button {
                id: showMeButton
                text: translator.translate("Show Me") + mainView.forceTranslate
                onClicked: map.showMe(true, true)
                visible: true
            }

//            Button {
//                id: navigateButton
//                text: translator.translate("Navigate") + mainView.forceTranslate
//                onClicked: mapView.navigateButtonClicked()
//            }

            Button {
                id : searchButton
                width: 156
                height: 53
                text: translator.translate("Search") + mainView.forceTranslate
                visible: true
                onClicked: searchButtonClicked()
            }

            Button {
                id: stopNavigation
                text: translator.translate("Stop Nav") + mainView.forceTranslate
                visible: false
                onClicked: Logic.stopNavigation()
            }

            ToggleButton {
                id: followMe
                text: translator.translate("Follow Me") + mainView.forceTranslate
                isSelected: false
                visible: isGPSDataValid
            }
        }
    }

    titlebarMiddleItems: VisualItemModel {
        Flow {
            spacing: 10
            Rectangle {
                id: gpsState
                border.color: "black"
                color:  isGPSDataValid? "green" : "red"
                radius: 3

                height: gpsStateText.height
                width: gpsStateText.width

                Text {
                    id: gpsStateText
                    text: mainView.forceTranslate + isGPSDataValid? translator.translate("GPS OK") : translator.translate("GPS BAD")
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 18
                }
            }

            Button {
                id: settingsButton
                text: translator.translate("Settings") + mainView.forceTranslate
                onClicked: settingsButtonClicked()
            }
        }
    }

    QwazerMap {
        id: map

        gpsData: positionSource
        anchors.fill: mapPage.content
    }

    states: [
        State {
            name: "BrowseState"

            PropertyChanges {
                target: mapView
                title: translator.translate("Browse Map") + mainView.forceTranslate
            }

            PropertyChanges {
                target: navigateButton
                visible: isGPSDataValid
            }

            PropertyChanges {
                target: searchButton
                visible: true
            }

            PropertyChanges {
                target: showMeButton
                visible: isGPSDataValid && !followMe.isSelected
            }

            PropertyChanges {
                target: currentInstruction
                visible: false
            }

            PropertyChanges {
                target: locationUpdater
                onTriggered: Logic.showMe()
                running: true
            }

            PropertyChanges {
                target: webViewRotation
                angle: 0
            }
        },
        State {
            name: "NavigateState"

            PropertyChanges {
                target: mapView
                title: translator.translate("Navigation") + mainView.forceTranslate
            }

            PropertyChanges {
                target: stopNavigation
                visible: true
            }

            PropertyChanges {
                target: searchButton
                visible: false
            }

            PropertyChanges {
                target: navigateButton
                visible: false
            }

            PropertyChanges {
                target: showMeButton
                visible: false
                anchors.bottom: stopNavigation.top
                anchors.bottomMargin: 7
            }

            PropertyChanges {
                target: currentInstruction
                opacity: 0.7
                visible: true
            }

            PropertyChanges {
                target: followMe
                visible: true
                isSelected: true
            }

            PropertyChanges {
                target: locationUpdater
                onTriggered: Logic.syncLocation()
                running: true
            }

            PropertyChanges {
                target: map
                onCurrentGpsLocationChanged: {
                    // thanks to http://stackoverflow.com/questions/642555/how-do-i-calculate-the-azimuth-angle-to-north-between-two-wgs84-coordinates/1050914#1050914
                    var dx = currentGpsLocation.lon - previousGpsLocation.lon;
                    var dy = currentGpsLocation.lat - previousGpsLocation.lat;

                    var azimuth = (Math.PI/2) - Math.atan(dy/dx);
                    if (dx < 0) azimuth += Math.PI;
                    else if (dy < 0) azimuth = Math.PI;

                    var angle = azimuth*180/Math.PI;
                    console.log(angle);
                    webViewRotation.angle = -angle;
                }
            }
        }
    ]
}
