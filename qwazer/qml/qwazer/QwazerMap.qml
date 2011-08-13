import QtQuick 1.0
import QtWebKit 1.0
import QtMobility.systeminfo 1.1
import "js/MapLogic.js" as Logic

Rectangle {
    id: mapView

    width: parent.width
    height: parent.height

    signal mapLoaded

    property ListModel navigationCoords: ListModel {}
    property ListModel navigationSegments: ListModel {}
    property variant currentSegment

    property variant previousGpsLocation
    property variant currentGpsLocation

    property bool mapRotates: false

    property bool isFollowMe: false

    property bool navigationScreenStaysLit: settings.navigationScreenStaysLit

    function navigate(course) {
        //refresh the stay lit settings
        screenSaver.setScreenSaverInhibit(settings.navigationScreenStaysLit);

        navigationCoords.clear();
        navigationCoords.append({x: course.results[0].path.x, y: course.results[0].path.y, length: 0}); //append starting point as it is not received
        for (var coordKey in course.coords)
        {
            // {"x":34.916002980775986,"y":32.505133295789356,"z":NaN}
            var coord = course.coords[coordKey];
            navigationCoords.append({x: coord.x, y: coord.y, z: coord.z});
        }

        var coordIndex = 0;
        navigationSegments.clear();
        for (var segKey in course.results)
        {
            // {"path":{"segmentId":149540,"nodeId":116390,"x":34.920114,"y":32.504936},"street":0,"distance":0,"length":34,"crossTime":0,"crossTimeWithoutRealTime":0,"tiles":null,"clientIds":null,"instruction":{"name":null,"opcode":"ROUNDABOUT_RIGHT","arg":0},"knownDirection":true,"penalty":0,"roadType":2}
            var segment = course.results[segKey];

            for (var coordPath = navigationCoords.get(coordIndex); coordIndex < navigationCoords.count && segment.path.x != coordPath.x || segment.path.y != coordPath.y; coordPath = navigationCoords.get(++coordIndex));
//            console.log("found matching coord index " + coordIndex);
            if (typeof(segment.instruction) != "undefined" && segment.instruction.opcode != "CONTINUE")
            {
                // continue should not invoke any info
                navigationCoords.setProperty(coordIndex, "length", 0);

                if (coordIndex < navigationCoords.count)
                {
                    for (var backtrackCoordIndex = coordIndex; backtrackCoordIndex > 0 && navigationCoords.get(backtrackCoordIndex-1).length !== 0; backtrackCoordIndex--)
                    {
                        var currentCoordPath = navigationCoords.get(backtrackCoordIndex);
                        var prevCoordPath = navigationCoords.get(backtrackCoordIndex-1);
                        var distance = Logic.computeDistance(currentCoordPath, prevCoordPath);
                        navigationCoords.setProperty(backtrackCoordIndex-1, "length", distance + currentCoordPath.length);
//                        console.log("coord index " + (backtrackCoordIndex-1) + " set with total length " + (distance + currentCoordPath.length) + " distance " + distance + " length " + currentCoordPath.length);
                    }
                }
            }

            navigationSegments.append({path: segment.path,
                                    street: segment.street,
                                    distance: segment.distance,
                                    length: segment.length,
                                    crossTime: segment.crossTime,
                                    crossTimeWithoutRealTime: segment.crossTimeWithoutRealTime,
                                    tiles: segment.tiles,
                                    clientIds: segment.clientIds,
                                    instruction: segment.instruction,
                                    knownDirection: segment.knownDirection,
                                    penalty: segment.penalty,
                                    roadType: segment.roadType,
                                    streetName: segment.streetName});
        }

        currentSegment = navigationSegments.get(0);
        Logic.navigate(course.coords);
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

        states: [
            State {
                name: "Rotate"
                when: mapView.mapRotates
                PropertyChanges {
                    target: mapView
                    onCurrentGpsLocationChanged: webViewRotation.angle = computeMapAngle()
                }
            },
            State {
                name: "Fixed"
                when: !mapView.mapRotates
                PropertyChanges {
                    target: webViewRotation
                    angle: 0
                }
            }
        ]
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

        instructionArg: (typeof(mapView.currentSegment) != "undefined" && typeof(mapView.currentSegment.instruction) != "undefined")? mapView.currentSegment.instruction.arg : 0
        instructionOpcode: (typeof(mapView.currentSegment) != "undefined" && typeof(mapView.currentSegment.instruction) != "undefined")? mapView.currentSegment.instruction.opcode : ""
    }

    InstructionsControl {
        id: currentInstruction
        visible: true
        opacity: 0.7
        anchors.bottom: futureDirections.visible? futureDirections.top : mapView.bottom
        anchors.left: mapView.left
        length: (typeof(mapView.currentSegment) != "undefined")? mapView.currentSegment.length : 0
        instructionArg: (typeof(mapView.currentSegment) != "undefined" && typeof(mapView.currentSegment.instruction) != "undefined")? mapView.currentSegment.instruction.arg : 0
        instructionOpcode: (typeof(mapView.currentSegment) != "undefined" && typeof(mapView.currentSegment.instruction) != "undefined")? mapView.currentSegment.instruction.opcode : ""
        streetName: (typeof(mapView.currentSegment) != "undefined" && typeof(mapView.currentSegment.streetName) != "undefined")? mapView.currentSegment.streetName : ""
    }

    DirectionGuideList {
        id: futureDirections
        anchors.left: mapView.left
        anchors.bottom: mapView.bottom
        model: mapView.navigationSegments
    }


    ScreenSaver {
        id: screenSaver
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
                target: mapView
                onNavigationScreenStaysLitChanged: screenSaver.setScreenSaverInhibit(navigationScreenStaysLit)
            }
        }
    ]
}
