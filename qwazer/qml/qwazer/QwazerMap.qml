import QtQuick 1.0
import QtWebKit 1.0
import "js/MapLogic.js" as Logic
import com.meego 1.0

Rectangle {
    id: mapView

    width: 780
    height: 400

    signal mapLoaded

    property variant navigationInfo

    property int currentCoordIndex : 0
    property int currentSegmentsInfoIndex : 0

    property variant previousGpsLocation
    property variant currentGpsLocation

    property alias mapAngle: webViewRotation.angle

    property bool isFollowMe: false

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

    function showMe() {
        Logic.showMe();
    }

    function syncLocation() {
        Logic.syncLocation();
    }

    WebView {
        id: web_view1

        width: Math.max(mapView.width, mapView.height)*Math.max(mapView.width, mapView.height)/Math.min(mapView.width, mapView.height)
        height: Math.max(mapView.width, mapView.height)*Math.max(mapView.width, mapView.height)/Math.min(mapView.width, mapView.height)
        x: (mapView.width-width)/2
        y: (mapView.height-height)/2

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
            onClicked: Logic.zoomIn()
        }

        Button {
            id: zoomOutButton
            width: 70
            height: width
            text: "-"
            onClicked: Logic.zoomOut()
        }

    }

//    InstructionsControl {
//        id: currentInstruction
//        visible: false
//        anchors.bottom: mapView.bottom
//        anchors.bottomMargin: 7
//        anchors.left: mapView.left
//    }

}
