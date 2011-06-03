import QtQuick 1.0
import QtWebKit 1.0
import "js/MapLogic.js" as Logic
import QtMobility.location 1.1

Rectangle {
    id: mapView
    anchors.fill: parent

    signal mapLoaded
    signal searchButtonClicked
    signal navigateButtonClicked

    width: 780
    height: 400

    ListModel {
        id: searchResultList
    }

    function setCenter(lon, lat) {
       Logic.setCenter(lon, lat);
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

    function navigate(route, coords) {
        Logic.navigate(route, coords);
    }

    PositionSource {
        id: positionSource
        active: true
        //nmeaSource: "nmealog.txt"
    }

    WebView {
        id: web_view1
        anchors.rightMargin: 8
        anchors.topMargin: 0
        anchors.bottomMargin: 7
        anchors.fill: parent
        pressGrabTime: 0

        onAlert: console.log(message)

        url: 'html/waze.html'

        onLoadFinished: mapView.mapLoaded()

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
        onClicked: Logic.showMe()
        enabled: positionSource.position.longitudeValid && positionSource.position.latitudeValid
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

        onClicked: mapView.navigateButtonClicked()
    }

    Timer {
        id: syncLocation
        interval: 2000;
        running: false;
        repeat: true
        onTriggered: Logic.showMe()
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
        onClicked: {
            syncLocation.stop();
            web_view1.state = "BrowseState";
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
                anchors.left: parent.left
                anchors.leftMargin: 7
                anchors.bottom: searchButton.top
                anchors.bottomMargin: 7
            }
        },
        State {
            name: "NavigateState"

            PropertyChanges {
                target: stopNavigation
                opacity: 1
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
                anchors.bottom: stopNavigation.top
                anchors.bottomMargin: 7
            }
        }
    ]
}
