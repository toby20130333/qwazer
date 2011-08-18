import QtQuick 1.0
import QtWebKit 1.0
import "js/MapLogic.js" as Logic

Rectangle {
    id: mapView

    width: parent.width
    height: parent.height

    signal mapLoaded

    property ListModel navigationSegments: ListModel {}
    property variant currentSegment

    property variant previousGpsLocation
    property variant currentGpsLocation

    property bool isFollowMe: false

    function navigate(course) {

        var coordIndex = 0;
        var segmentIndex = 0;

        navigationSegments.clear();
        for (; segmentIndex < course.results.length; segmentIndex++)
        {
            var segment = course.results[segmentIndex];
            for (; coordIndex < course.coords.length; coordIndex++)
            {
                var coord = course.coords[coordIndex];
                if (segmentIndex + 1 < course.results.length &&
                    course.results[segmentIndex+1].path.x == coord.x &&
                    course.results[segmentIndex+1].path.y == coord.y)
                {
                    break;
                }

                navigationSegments.append({segmentId: segmentIndex,
                                        path: {x: coord.x, y: coord.y},
                                        street: segment.street,
                                        distance: segment.distance,
                                        length: segment.length,
                                        crossTime: segment.crossTime,
                                        crossTimeWithoutRealTime: segment.crossTimeWithoutRealTime,
                                        tiles: segment.tiles,
                                        clientIds: segment.clientIds,
                                        instruction: (typeof(segment.instruction) != "undefined")? segment.instruction : {opcode: "CONTINUE", arg: 0},
                                        knownDirection: segment.knownDirection,
                                        penalty: segment.penalty,
                                        roadType: segment.roadType,
                                        streetName: segment.streetName});
            }
        }

        // update lengths
        navigationSegments.setProperty(navigationSegments.count-1, "length", 0);
        for (segmentIndex = navigationSegments.count-2; segmentIndex >= 0; segmentIndex--)
        {
            var currentSegment = navigationSegments.get(segmentIndex);
            var nextSegment = navigationSegments.get(segmentIndex+1);
            var length = 0;

            if (currentSegment.segmentId == nextSegment.segmentId ||
                (currentSegment.instruction.opcode == "CONTINUE" && nextSegment.instruction.opcode == "CONTINUE"))
            {
                length = nextSegment.length + Logic.computeDistance(currentSegment.path, nextSegment.path);
            } else {
                length = 0;
            }

            navigationSegments.setProperty(segmentIndex, "length", length);
        }

        Logic.navigate(course.coords);
        mapView.currentSegment = navigationSegments.get(0);
    }

    ListModel {
        id: searchResultList
    }

    function initialize() {
        if (typeof(settings.lastKnownPosition) != "undefined" &&
            typeof(settings.lastKnownPosition.lon) != "undefined" &&
            typeof(settings.lastKnownPosition.lat) != "undefined")
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

    function zoomIn() {
        Logic.zoomIn();
    }

    function zoomOut() {
        Logic.zoomOut();
    }

    function markDestination(lon, lat) {
        Logic.markDestination(lon, lat);
    }

    function markOrigin(lon, lat) {
        Logic.markOrigin(lon, lat);
    }

    function showLocation(lon, lat) {
        Logic.showLocation(lon, lat);
    }

    function showMe(shouldCenter, shouldZoom) {
        Logic.showMe(shouldCenter, shouldZoom);
    }

    function syncLocation() {
        Logic.showMe();
        Logic.syncLocation();
    }

    function stopNavigation() {
        Logic.stopNavigation();
    }

    function computeMapAngle() {
        // thanks to http://stackoverflow.com/questions/642555/how-do-i-calculate-the-azimuth-angle-to-north-between-two-wgs84-coordinates/1050914#1050914
        if (!currentGpsLocation ||
            !previousGpsLocation ||
            currentGpsLocation.lon == previousGpsLocation.lon)
        {
            return 0;
        }

        var dx = currentGpsLocation.lon - previousGpsLocation.lon;
        var dy = currentGpsLocation.lat - previousGpsLocation.lat;

        var azimuth = (Math.PI/2) - Math.atan(dy/dx);
        if (dx < 0) azimuth += Math.PI;
        else if (dy < 0) azimuth = Math.PI;

        var mapAngle = azimuth*180/Math.PI;
        return (mapAngle>-180)? -mapAngle : mapAngle;
    }

    WebView {
        id: web_view1

        width: Math.max(parent.width, parent.height) + Math.abs(parent.width - parent.height)/2
        height: Math.max(parent.width, parent.height) + Math.abs(parent.width - parent.height)/2
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        pressGrabTime: 0
        settings.offlineWebApplicationCacheEnabled: true

        transform: Rotation {
            id: webViewRotation
            origin.x: Math.floor(web_view1.width/2)
            origin.y: Math.floor(web_view1.height/2)
            axis{ x: 0; y: 0; z:1 }

            Behavior on angle {
                PropertyAnimation{
                    duration: gpsData.updateInterval/4;
                    easing.type: Easing.InOutSine
                }
            }
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
        id: zoomButtons
        anchors.right: mapView.right
        anchors.rightMargin: 50
        anchors.verticalCenter: mapView.verticalCenter
        spacing: 75
        width: 50

        ListItem {
            text: "+"
            onClicked: mapView.zoomIn()
            radius: height
            width: height
            smooth: true
        }


        ListItem {
            text: "-"
            onClicked: mapView.zoomOut()
            radius: height
            width: height
            smooth: true
        }
    }

    DirectionGuideControl {
        id: fullScreenInstruction
        border.color: "#00000000"
        anchors.horizontalCenter: mapView.horizontalCenter
        anchors.verticalCenter: mapView.verticalCenter
        opacity: 0.3
        color: "#00000000"

        diameter: Math.min(mapView.width, mapView.height) - 100

        instructionArg: (typeof(mapView.currentSegment) != "undefined")? mapView.currentSegment.instruction.arg : 0
        instructionOpcode: (typeof(mapView.currentSegment) != "undefined")? mapView.currentSegment.instruction.opcode : ""
    }

    InstructionsControl {
        id: currentInstruction
        visible: true
        opacity: 0.7
        anchors.bottom: futureDirections.visible? futureDirections.top : mapView.bottom
        anchors.left: mapView.left
        length: (typeof(mapView.currentSegment) != "undefined")? mapView.currentSegment.length : 0
        instructionArg: (typeof(mapView.currentSegment) != "undefined")? mapView.currentSegment.instruction.arg : 0
        instructionOpcode: (typeof(mapView.currentSegment) != "undefined")? mapView.currentSegment.instruction.opcode : ""
        streetName: (typeof(mapView.currentSegment) != "undefined" && typeof(mapView.currentSegment.streetName) != "undefined")? mapView.currentSegment.streetName : ""
    }

    DirectionGuideList {
        id: futureDirections
        anchors.left: mapView.left
        anchors.bottom: mapView.bottom
        model: mapView.navigationSegments
    }

    states: [
        State {
            name: "Browse"
            PropertyChanges {
                target: currentInstruction
                visible: false
            }
            PropertyChanges {
                target: futureDirections
                visible: false
            }
            PropertyChanges {
                target: fullScreenInstruction
                visible: false
            }
            PropertyChanges {
                target: mapView
                onCurrentGpsLocationChanged: webViewRotation.angle = 0;
            }
        },
        State {
            name: "Navigation"

            PropertyChanges {
                target: currentInstruction
                visible: true
            }
            PropertyChanges {
                target: futureDirections
                visible: settings.navigationShowNextTurns
            }
            PropertyChanges {
                target: fullScreenInstruction
                visible: settings.navigationFullscreenInstruction
            }
            PropertyChanges {
                target: navigationSegments
                onCountChanged:  mapView.currentSegment = navigationSegments.get(0)
            }
            PropertyChanges {
                target: mapView
                onCurrentGpsLocationChanged: {
                    if (navigationSegments.count > 0)
                    {
                        var nextSegment = navigationSegments.get(1);
                        currentSegment.length = nextSegment.length + Logic.computeDistance(currentGpsLocation, nextSegment.path);
                    }

                    webViewRotation.angle = (!settings.navigationNorthLocked)? computeMapAngle() : 0;
                }
            }
        }
    ]
}
