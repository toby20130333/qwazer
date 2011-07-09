import QtQuick 1.0
import QtWebKit 1.0
import "js/MapLogic.js" as Logic
import "common_qml"

Page {
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
        if (typeof(settings.lastKnownPosition) != "undefined")
        {
            savedMapData.location_lon = settings.lastKnownPosition.lon;
            savedMapData.location_lat = settings.lastKnownPosition.lat;
        }
        else
        {
            savedMapData.location_lon = settings.country.lon;
            savedMapData.location_lat = settings.country.lat;
        }

        savedMapData.locale = settings.country.locale;
        savedMapData.map_url = settings.country.map_url;
        savedMapData.ws_url = settings.country.ws_url;
        savedMapData.zoom = settings.zoom;

        mapView.state = "BrowseState";
        web_view1.url = 'html/waze.html';
    }

    function reload() {
        console.log("reload requested");
        initialize();
        web_view1.reload.trigger();
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

    toolbarLeftItems: VisualItemModel {}

    toolbarMiddleItems: VisualItemModel {
        Flow {
            spacing: 10

            Button {
                id: showMeButton
                text: translator.translate("Show Me") + mainView.forceTranslate
                onClicked: Logic.showMe(true, true)
                visible: true
            }

            Button {
                id: navigateButton
                text: translator.translate("Navigate") + mainView.forceTranslate
                onClicked: mapView.navigateButtonClicked()
            }

            Button {
                id : searchButton
                width: 156
                height: 53
                text: translator.translate("Search") + mainView.forceTranslate
                visible: true
                onClicked: mapView.searchButtonClicked()
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

    titlebarItems: VisualItemModel {
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

    Rectangle {
        id: mapContent

        anchors.fill: mapView.content

        WebView {
            id: web_view1

            width: Math.max(mapContent.width, mapContent.height)*Math.max(mapContent.width, mapContent.height)/Math.min(mapContent.width, mapContent.height)
            height: Math.max(mapContent.width, mapContent.height)*Math.max(mapContent.width, mapContent.height)/Math.min(mapContent.width, mapContent.height)
            x: (mapContent.width-width)/2
            y: (mapContent.height-height)/2

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

        Column {
            id: zoomInOutButtons
            spacing: 100

            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter

            Button {
                id: zoomInButton
                width: 70
                height: width
                text: "+"
                radius: width
                onClicked: Logic.zoomIn()
            }

            Button {
                id: zoomOutButton
                width: 70
                height: width
                text: "-"
                radius: width
                onClicked: Logic.zoomOut()
            }

        }

        Timer {
            id: locationUpdater
            interval: 1500
            repeat: true
            running: false
        }

        InstructionsControl {
            id: currentInstruction
            visible: false
            anchors.bottom: mapContent.bottom
            anchors.bottomMargin: 7
            anchors.left: mapContent.left
        }
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
