import QtQuick 1.0
import QtWebKit 1.0
import "js/MapLogic.js" as Logic

Rectangle {
    id: mapView

    width: 780
    height: 400

    signal mapLoaded
    signal searchButtonClicked
    signal settingsButtonClicked
    signal navigateButtonClicked

    property variant gpsData
    property variant navigationInfo

    property int currentCoordIndex : 0
    property int currentSegmentsInfoIndex : 0

    property bool isGPSDataValid :  gpsData.position.verticalAccuracyValid &&
                                    gpsData.position.horizontalAccuracyValid &&
                                    gpsData.position.verticalAccuracy < 100 &&
                                    gpsData.position.horizontalAccuracy < 100

    property variant previousGpsLocation
    property variant currentGpsLocation

    onNavigationInfoChanged: {
        Logic.navigate();
    }

    ListModel {
        id: searchResultList
    }

    function initialize() {
        savedMapData.location_lon = settings.country.lon;
        savedMapData.location_lat = settings.country.lat;
        if (typeof(settings.lastKnownPosition) != "undefined")
        {
            savedMapData.location_lon = settings.lastKnownPosition.lon;
            savedMapData.location_lat = settings.lastKnownPosition.lat;
        }
        savedMapData.locale = settings.country.locale;
        savedMapData.map_url = settings.country.map_url;
        savedMapData.ws_url = settings.country.ws_url;
        savedMapData.zoom = settings.zoom;

        mapView.state = "BrowseState";
        web_view1.url = 'html/waze.html';
    }

    function setCenter(lon, lat) {
       Logic.setCenter(lon, lat);
    }

    function setZoom(zoom) {
       Logic.setZoom(zoom);
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

        width: Math.max(parent.width, parent.height)*Math.max(parent.width, parent.height)/Math.min(parent.width, parent.height)
        height: Math.max(parent.width, parent.height)*Math.max(parent.width, parent.height)/Math.min(parent.width, parent.height)
        x: (parent.width-width)/2
        y: (parent.height-height)/2

        pressGrabTime: 0
        settings.offlineWebApplicationCacheEnabled: true

        transform: Rotation {
            id: webViewRotation
            origin.x: Math.floor(web_view1.width/2)
            origin.y: Math.floor(web_view1.height/2)
            axis{ x: 0; y: 0; z:1 }

            Behavior on angle { PropertyAnimation{ duration: locationUpdater.interval*0.9; easing.type: Easing.InOutSine} }
        }

        javaScriptWindowObjects: [
            QtObject {
                id: savedMapData
                WebView.windowObjectName: "savedMapData"

                property bool lon_lat_changed:  false

                function setLastKnownLocation(lon, lat) {
                    if (lon_lat_changed)
                    {
                        Logic.setLastKnownPosition(location_lon, location_lat);
                    }
                    lon_lat_changed = !lon_lat_changed;
                }


                property string location_lon
                onLocation_lonChanged: setLastKnownLocation(location_lon, location_lat)

                property string location_lat
                onLocation_latChanged: setLastKnownLocation(location_lon, location_lat)

                property string locale

                property string map_url
                property string ws_url

                property int zoom
            }
        ]

        onAlert: console.log(message)

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
        text: translator.translate("Show Me") + mainView.forceTranslate
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.bottom: searchButton.top
        anchors.bottomMargin: 7
        onClicked: Logic.showMe(true, true)
        visible: true
    }

    Button {
        id: navigateButton
        text: translator.translate("Navigate") + mainView.forceTranslate
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 7
        width: 156
        height: 51

        onClicked: mapView.navigateButtonClicked()
    }

    Timer {
        id: locationUpdater
        interval: 1500
        repeat: true
        running: false
    }

    Button {
        id : searchButton
        width: 156
        height: 53
        text: translator.translate("Search") + mainView.forceTranslate
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.bottom: navigateButton.top
        anchors.bottomMargin: 7
        visible: true
        onClicked: mapView.searchButtonClicked()
    }

    Button {
        id: stopNavigation
        text: translator.translate("Stop Nav") + mainView.forceTranslate
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

    ToggleButton {
        id: followMe
        text: translator.translate("Follow Me") + mainView.forceTranslate
        anchors.right: gpsState.right
        anchors.bottom: gpsState.top
        anchors.bottomMargin: 7
        isSelected: false
        visible: isGPSDataValid
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
            text: mainView.forceTranslate + isGPSDataValid? translator.translate("GPS OK") : translator.translate("GPS BAD")
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

    Button {
        id: settingsButton
        anchors.top: parent.top
        anchors.topMargin: 7
        anchors.right: parent.right
        anchors.rightMargin: 7

        text: translator.translate("Settings") + mainView.forceTranslate
        onClicked: settingsButtonClicked()
    }

    states: [
        State {
            name: "BrowseState"

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
                target: mapView
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
