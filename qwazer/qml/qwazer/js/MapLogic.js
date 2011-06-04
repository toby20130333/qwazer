var ERROR_MARGIN = 0.0002;


function zoomIn() {
    web_view1.evaluateJavaScript("g_waze_map.map.zoomIn();");
}

function zoomInToMax() {
    web_view1.evaluateJavaScript("g_waze_map.map.zoomToScale(g_waze_map.map.maxScale);");
}

function zoomOut() {
    web_view1.evaluateJavaScript("g_waze_map.map.zoomOut();");
}

function getCurrentExtent() {
    return web_view1.evaluateJavaScript("g_waze_map.map.getExtent();");
}

function setCenter(lon, lat)
{
    web_view1.evaluateJavaScript("g_waze_map.map.setCenter(new OpenLayers.LonLat('" + lon + "','" + lat + "'));");
}

function markDestination(lon, lat)
{
    console.log("mark destinitaion was requested for " + lon + ":" + lat);
    console.log("TODO");
}

function markOrigin(lon, lat)
{
    console.log("mark origin was requested for " + lon + ":" + lat);
    console.log("TODO");
}

function showLocation(lon, lat)
{
    console.log("show location was requested for " + lon + ":" + lat);
    setCenter(lon,lat);
    console.log("TODO - add landmark");
}

function showMe(shouldZoom)
{
    web_view1.evaluateJavaScript("markMyLocation("+gpsData.position.coordinate.longitude+","+gpsData.position.coordinate.latitude+");");
    setCenter(gpsData.position.coordinate.longitude, gpsData.position.coordinate.latitude);
    if (shouldZoom)
    {
        zoomInToMax();
    }
}

function navigate()
{
    clearMarkersAndRoute();

    mapView.currentCoordIndex = 0;
    mapView.currentSegmentsInfoIndex = 0;

    setCenter(mapView.navigationInfo.coords[0].x, mapView.navigationInfo.coords[0].y);
    zoomInToMax();

    var coordsJSON = JSON.stringify(mapView.navigationInfo.coords);
    web_view1.evaluateJavaScript("plotCourse("+coordsJSON+");");

    mapView.state = "NavigateState";
    currentInstruction.sectionData = mapView.navigationInfo.results[0];

    locationUpdater.start();
}

function syncLocation()
{
    var currentCoordIndex = mapView.currentCoordIndex;
    var currentSegmentsInfoIndex = mapView.currentSegmentsInfoIndex;
    showMe();

    var onTrack = false;
    var trimOccured = false;

    var coords = mapView.navigationInfo.coords;
    var segmentsInfo = mapView.navigationInfo.results;

    for (var coordsIndex=0; onTrack == false && coordsIndex < 50 && coordsIndex+currentCoordIndex < coords.length-1; coordsIndex++)
    {

        console.log(coords[coordsIndex].x + " " + segmentsInfo[currentSegmentsInfoIndex].path.x + "\n" + coords[coordsIndex].y + " " + segmentsInfo[currentSegmentsInfoIndex].path.y)
        if (coords[coordsIndex].x == segmentsInfo[currentSegmentsInfoIndex+1].path.x &&
            coords[coordsIndex].y == segmentsInfo[currentSegmentsInfoIndex+1].path.y )
        {
            currentSegmentsInfoIndex++;
            mapView.currentSegmentsInfoIndex = currentSegmentsInfoIndex;
            trimOccured = true;
        }

        if (isOnTrack({x:gpsData.position.coordinate.longitude, y:gpsData.position.coordinate.latitude},
                       coords[coordsIndex+currentCoordIndex],
                       coords[coordsIndex + 1 +currentCoordIndex]))
        {
            if (coordsIndex >0)
            {
                currentCoordIndex += coordsIndex;
                mapView.currentCoordIndex = currentCoordIndex;
            }

            onTrack = true;
        }
    }

    if (onTrack && trimOccured)
    {
        currentInstruction.sectionData = segmentsInfo[currentSegmentsInfoIndex];
    }
    else if (!onTrack)
    {
        // TODO reroute
        console.log("need reroute - stopping navigation!!!");
        stopNavigation();
    }
}

function clearMarkersAndRoute()
{
    web_view1.evaluateJavaScript("clearMarkersAndRoute();");
}

function isOnTrack(loc, startPoint, endPoint)
{
    var slope = (endPoint.y - startPoint.y)/(endPoint.x - startPoint.x);
    var intrSection = endPoint.y-(slope*endPoint.x);
    var rc = Math.abs((slope * loc.x + intrSection) - loc.y) < ERROR_MARGIN;
    console.log("is on track:" + rc)
    return rc;
}

function stopNavigation()
{
    locationUpdater.stop();
    web_view1.evaluateJavaScript("clearMarkersAndRoute();");
    mapView.state = "BrowseState";
}
