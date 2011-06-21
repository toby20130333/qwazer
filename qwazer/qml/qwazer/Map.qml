import QtQuick 1.0
import QtWebKit 1.0
import "js/MapLogic.js" as Logic

Rectangle {
    id: mapView
    anchors.fill: parent

    width: 780
    height: 400

    signal mapLoaded
    signal searchButtonClicked
    signal navigateButtonClicked

    property variant gpsData
    property variant navigationInfo

    property int currentCoordIndex : 0
    property int currentSegmentsInfoIndex : 0

    property bool isGPSDataValid :  gpsData.position.verticalAccuracyValid &&
                                    gpsData.position.horizontalAccuracyValid &&
                                    gpsData.position.verticalAccuracy < 20 &&
                                    gpsData.position.horizontalAccuracy < 20

    SystemPalette { id: activePalette }

    onNavigationInfoChanged: {
        Logic.navigate();
    }

    ListModel {
        id: searchResultList
    }

    function setCenter(lon, lat) {
       Logic.setCenter(lon, lat);
    }

    function setZoom(zoom) {
       Logic.setZoom(zoom);
    }

    function rotate(degress) {
       console.log("rotate - TODO");
    }

    function markDestination(lon, lat) {
        Logic.markDestination(lon, lat);
    }

    function markOrigin(lon, lat) {
        Logic.markOrigin(lon, lat);
    }

    function search(address) {
        Logic.search(address);
    }

    function showLocation(lon, lat) {
        Logic.showLocation(lon, lat);
    }

    WebView {
        id: web_view1

        anchors.fill: parent
        pressGrabTime: 0
        settings.offlineWebApplicationCacheEnabled: true


        javaScriptWindowObjects: [
            QtObject {
                id: savedMapData
                objectName: "savedMapData"

                property variant lon: 34.7898
                property variant lat: 32.08676

                property int zoom: 8
            }
        ]

        onAlert: console.log(message)

        url: 'html/waze.html'

        onLoadFinished: {
            evaluateJavaScript("loadSavedData();")
            mapView.mapLoaded();
        }
    }

    Button {
        id: zoomInButton
        width: 67
        height: 39
        text: "+"
        anchors.top: parent.top
        anchors.topMargin: 7
        anchors.left: zoomOutButton.right
        anchors.leftMargin: 30
        onClicked: Logic.zoomIn()
    }

    Button {
        id: zoomOutButton
        width: 62
        height: 41
        text: "-"
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 7
        onClicked: Logic.zoomOut()
    }

    Button {
        id: showMeButton
        width: 156
        height: 52
        text: "הצג אותי"
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.bottom: searchButton.top
        anchors.bottomMargin: 7
        onClicked: Logic.showMe(true)
        visible: true
    }

    Button {
        id: navigateButton
        text: "נווט"
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 7
        width: 156
        height: 51
        visible: true

        onClicked: mapView.navigateButtonClicked()
    }

    Timer {
        id: locationUpdater
        interval: 2000
        repeat: true
        running: false
        onTriggered: Logic.syncLocation()
    }

    Button {
        id : searchButton
        width: 156
        height: 53
        text: "חפש"
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.bottom: navigateButton.top
        anchors.bottomMargin: 7
        visible: true
        onClicked: mapView.searchButtonClicked()
    }

    Button {
        id: stopNavigation
        text: "הפסק ניווט"
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 7
        visible: false
        onClicked: Logic.stopNavigation()
    }

    InstructionsControl {
        id: currentInstruction
        visible: false
        anchors.bottom: stopNavigation.top
        anchors.bottomMargin: 7
        anchors.left: stopNavigation.left
        anchors.right: stopNavigation.right
    }

    Button {
        id: followMe
        text: "עקוב אחרי"
        anchors.right: gpsState.right
        anchors.bottom: gpsState.top
        anchors.bottomMargin: 7
        visible: false

        onClicked: isSelected = !isSelected

        property bool isSelected : true

        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: !followMe.isSelected ? activePalette.light : activePalette.button
            }
            GradientStop {
                position: 1.0
                color: !followMe.isSelected ? activePalette.button : activePalette.dark
            }
        }
    }

    Rectangle {
        id: gpsState

        anchors.right: parent.right
        anchors.rightMargin: 7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 7
        border.color: "black"
        color:  isGPSDataValid? "green" : "red"
        radius: 3

        height: 50
        width: 150

        Text {
            id: gpsStateText
            text: isGPSDataValid? "GPS OK" : "GPS BAD"
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 18
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
        }
    }

    states: [
        State {
            name: "BrowseState"

            PropertyChanges {
                target: navigateButton
                visible: true
            }

            PropertyChanges {
                target: searchButton
                visible: true
            }

            PropertyChanges {
                target: showMeButton
                visible: true
            }

            PropertyChanges {
                target: currentInstruction
                visible: false
            }
        },
        State {
            name: "NavigateState"

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
            }
        }
    ]
}
