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
    showMe();

    var onTrack = false;
    var trimOccured = false;
    for (var coordsIndex=0; onTrack == false && coordsIndex < 50 && coordsIndex < mapView.navigationInfo.coords.length-1; coordsIndex++)
    {
        console.log("coordsIndex = " + coordsIndex);
        if (isOnTrack({x:gpsData.position.coordinate.longitude, y:gpsData.position.coordinate.latitude},
                       mapView.navigationInfo.coords[coordsIndex],
                       mapView.navigationInfo.coords[coordsIndex+1]))
        {
            console.log(mapView.navigationInfo.coords[coordsIndex+1].x + " " + mapView.navigationInfo.results[0].path.x + "\n" + mapView.navigationInfo.coords[coordsIndex+1].y + " " + mapView.navigationInfo.results[0].path.y)
            if (mapView.navigationInfo.coords[coordsIndex+1].x == mapView.navigationInfo.results[0].path.x &&
                mapView.navigationInfo.coords[coordsIndex+1].y == mapView.navigationInfo.results[0].path.y)
            {
                mapView.navigationInfo.results.splice(0,1);
                console.log("results trimmed by one");
                trimOccured = true;
            }

            if (coordsIndex >0)
            {
                mapView.navigationInfo.coords.splice(0,coordsIndex);
                console.log("coords trimmed by:" + coordsIndex);
            }

            onTrack = true;
        }
    }

    if (onTrack && trimOccured)
    {
        currentInstruction.sectionData = mapView.navigationInfo.results[0];
    }
    else
    {
        // TODO reroute
        console.log("need reroute!!!");
        //stopNavigation();
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
    var rc = Math.abs((slope * loc.x + intrSection) - loc.y) < 0.0002;
    console.log("is on track:" + rc)
    return rc;
}

function stopNavigation()
{
    locationUpdater.stop();
    web_view1.evaluateJavaScript("clearMarkersAndRoute();");
    mapView.state = "BrowseState";
}
