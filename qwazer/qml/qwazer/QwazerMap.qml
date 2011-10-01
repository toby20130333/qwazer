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
    property variant nextSegment

    property variant previousGpsLocation
    property variant currentGpsLocation

    property bool isFollowMe: false

    Connections {
        target: settings
        onMapRefreshRequired: reload()
    }

    function navigate(course) {

        var blankInstruction = {opcode: "CONTINUE", arg: 0};

        var coordIndex = 0;
        var segmentIndex = 0;

        var inRoundabout = false;
        var roundaboutSegmentId = 0;
        var roundaboutInstruction = blankInstruction;

        navigationSegments.clear();
        for (; segmentIndex < course.results.length; segmentIndex++)
        {
            var segment = course.results[segmentIndex];
            if (typeof(segment.instruction) == "undefined") console.log("Missing instruction");
            for (; coordIndex < course.coords.length; coordIndex++)
            {
                var coord = course.coords[coordIndex];
                if (segmentIndex + 1 < course.results.length &&
                    course.results[segmentIndex+1].path.x == coord.x &&
                    course.results[segmentIndex+1].path.y == coord.y)
                {
                    break;
                }

                navigationSegments.append({segmentId: (inRoundabout)? roundaboutSegmentId : segmentIndex,
                                        path: {x: coord.x, y: coord.y},
                                        street: segment.street,
                                        distance: segment.distance,
                                        length: segment.length,
                                        crossTime: segment.crossTime,
                                        crossTimeWithoutRealTime: segment.crossTimeWithoutRealTime,
                                        tiles: segment.tiles,
                                        clientIds: segment.clientIds,
                                        instruction: ((inRoundabout)? roundaboutInstruction : (typeof(segment.instruction) != "undefined")? segment.instruction : blankInstruction),
                                        knownDirection: segment.knownDirection,
                                        penalty: segment.penalty,
                                        roadType: segment.roadType,
                                        streetName: segment.streetName});
            }

            if (segment.instruction)
            {
                console.log("added instruction: " + segment.instruction.opcode + " : " + segment.instruction.arg);
            }

            if (typeof(segment.instruction) != "undefined" && segment.instruction.opcode.indexOf("ROUNDABOUT_") === 0)
            {
                if (segment.instruction.opcode.indexOf("EXIT") > -1)
                {
                    // end of roundabout section
                    inRoundabout = false;
                    roundaboutSegmentId = 0;
                    roundaboutInstruction = blankInstruction;
                }
                else
                {
                    // starting/still in roundabout
                    inRoundabout = true;
                    roundaboutSegmentId = segmentIndex;
                    roundaboutInstruction = {opcode: segment.instruction.opcode, arg: segment.instruction.arg};
                }
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
                currentSegment.instruction.opcode == "CONTINUE")
            {
                length = nextSegment.length + Logic.computeDistance(currentSegment.path, nextSegment.path);
            } else {
                length = 0;
            }

            navigationSegments.setProperty(segmentIndex, "length", length);
        }
        console.log("navigate");
        Logic.navigate(course.coords);
        segmentCountChanged();
    }

    function segmentCountChanged() {
        mapView.currentSegment = navigationSegments.get(0);
        mapView.nextSegment = findNextSegment();
    }

    function findNextSegment() {
        var segment = null;
        for (var index = 1; index < mapView.navigationSegments.count; index++)
        {
            if (mapView.navigationSegments.get(index).length === 0)
            {
                segment = mapView.navigationSegments.get(index);
                break;
            }
        }
        return segment;
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
        savedMapData.maxZoom = settings.country.maxZoom;
        if (settings.zoom > settings.country.maxZoom)
        {
            settings.zoom = settings.country.maxZoom;
        }
        else if (settings.zoom < savedMapData.minZoom)
        {
            settings.zoom = savedMapData.minZoom;
        }
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

        width: Math.max(mapView.width, mapView.height) + Math.abs(mapView.width - mapView.height)/2
        height: Math.max(mapView.width, mapView.height) + Math.abs(mapView.width - mapView.height)/2
        anchors.verticalCenter: mapView.verticalCenter
        anchors.horizontalCenter: mapView.horizontalCenter

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

                property int minZoom: 1
                property int maxZoom: 0
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

        ZoomButton {
            text: "+"
            onZoom: mapView.zoomIn()
            clickable: settings.zoom < savedMapData.maxZoom
        }


        ZoomButton {
            text: "-"
            onZoom: mapView.zoomOut()
            clickable: settings.zoom > savedMapData.minZoom
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

    VoiceInstructor {
        id: voiceInstructor
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
                onCountChanged:  segmentCountChanged()
            }
            PropertyChanges {
                target: mapView
                onCurrentGpsLocationChanged: {
                    webViewRotation.angle = (!settings.navigationNorthLocked && isFollowMe)? computeMapAngle() : 0;

                    var notifyLength = -1;
                    var remainingSegmentLength = mapView.currentSegment.length;
                    var nextInstruction = mapView.nextSegment.instruction;

                    if (mapView.currentSegment.segmentId != mapView.nextSegment.segmentId)
                    {
                        return;
                    }

                    if (!mapView.nextSegment.notify20 && remainingSegmentLength < 20)
                    {
                        console.log("20");
                        mapView.nextSegment.notify20 = true;
                        notifyLength = 0;
                    }
                    else if (250 < remainingSegmentLength && remainingSegmentLength < 350 && !mapView.nextSegment.notify300)
                    {
                        console.log("300");
                        mapView.nextSegment.notify300 = true;
                        notifyLength = 300;
                    }
                    else if (700 < remainingSegmentLength && remainingSegmentLength < 900 && !mapView.nextSegment.notify800)
                    {
                        console.log("800");
                        mapView.nextSegment.notify800 = true;
                        notifyLength = 800;
                    }
                    else if (1900 < remainingSegmentLength && remainingSegmentLength < 2100 && !mapView.nextSegment.notify2000)
                    {
                        console.log("2000");
                        mapView.nextSegment.notify2000 = true;
                        notifyLength = 2000;
                    }

                    if (notifyLength > -1)
                    {
                        console.log("calling speak : " + nextInstruction.opcode + "#" + nextInstruction.arg);
                        voiceInstructor.speakScenario(notifyLength, nextInstruction.opcode, nextInstruction.arg);
                    }
                }
            }
        }
    ]
}
