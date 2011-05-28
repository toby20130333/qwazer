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

    PositionSource {
        id: positionSource
        active: true
        //nmeaSource: "nmealog.txt"
    }

    WebView {
        id: web_view1
        anchors.rightMargin: 10
        anchors.leftMargin: 0
        anchors.bottomMargin: 10
        anchors.topMargin: 0
        anchors.fill: parent
        pressGrabTime: 0

        onAlert: console.log(message)

        url: 'html/waze.html'

        onLoadFinished: mapView.mapLoaded()

    }

    Button {
        id: zoomInButton
        x: 17
        y: 10
        width: 67
        height: 39
        text: "+"
        onClicked: Logic.zoomIn()
    }

    Button {
        id: zoomOutButton
        x: 18
        y: 180
        width: 62
        height: 41
        text: "-"
        onClicked: Logic.zoomOut()
    }

    Button {
        id: showMeButton
        x: 11
        y: 225
        width: 156
        height: 52
        text: "הצג אותי"
        onClicked: Logic.showMe()
        enabled: positionSource.position.longitudeValid && positionSource.position.latitudeValid
    }

    Button {
        id: navigateButton
        text: "נווט"
        x: 11
        y: 344
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
        x: 11
        y: 282
        width: 156
        height: 53
        text: "חפש"
        visible: true
        onClicked: mapView.searchButtonClicked()
    }
}
