import QtQuick 1.0
import QtWebKit 1.0
import "js/MapLogic.js" as Logic
import QtMobility.location 1.1

Rectangle {
    id: mapView
    anchors.fill: parent

    signal mapLoaded

    width: 300
    height: 300

    Component.onCompleted: {
        web_view1.loadFinished.connect(mapLoaded);
    }

    ListModel {
        id: searchResultList
    }

    function zoomIn() {
       Logic.zoomIn();
    }

    function zoomOut() {
       Logic.zoomOut();
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
//        onPositionChanged: {console.log("position changed:" + position.coordinate.longitude + "," +position.coordinate.latitude)}
    }

    FindResultsModel {
        id: findModel
    }

    WebView {
        id: web_view1
        anchors.fill: parent
        pressGrabTime: 0

        onAlert: console.log(message)

        url: 'html/waze.html'

        Button {
            id : searchButton
            x: 41
            y: 327
            width: 64
            height: 43
            onClicked: {
                console.log('before set address');
                findModel.address = addressTextEdit.text;
                console.log('after set address');
            }
            text: "חפש"
            visible: true
        }

//        Timer {
//            interval: 2000; running: true; repeat: true
//            onTriggered: mapView.setCenter(35.574, 33.215)
//        }

    }

    Button {
        id: zoomInButton
        x: 249
        y: 58
        width: 45
        height: 29
        text: "הגדל"
        onClicked: Logic.zoomIn()
    }

    Button {
        id: zoomOutButton
        x: 175
        y: 58
        width: 47
        height: 29
        text: "מזער"
        onClicked: Logic.zoomOut()
    }

    Rectangle {
        id: rectangle1
        x: 130
        y: 314
        width: 156
        height: 34
        color: "#ffffff"
        border.color: "#000000"

        TextEdit {
            id: addressTextEdit
            text: "תל חי קריית שמונה"
            cursorVisible: true
            anchors.fill: parent
            selectedTextColor: "#00ffd5"
            selectionColor: "#0004ff"
            font.pixelSize: 12
        }
    }

    Button {
        id: showMeButton
        x: 70
        y: 59
        width: 67
        height: 29
        text: "הצג אותי"
        onClicked: Logic.showLocation(positionSource.position.coordinate.longitude, positionSource.position.coordinate.latitude)
        enabled: positionSource.position.longitudeValid && positionSource.position.latitudeValid
    }
}
