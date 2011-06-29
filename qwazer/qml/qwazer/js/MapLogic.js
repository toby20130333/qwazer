var ERROR_MARGIN = 0.0005;


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

function getNormalizedLonLat(lon, lat)
{
    if (settings.country.isSphericalMercator)
    {
        console.log("normalized");
        lon = (lon / 20037508.34) * 180;
        lat = (lat / 20037508.34) * 180;
        lat = 180/Math.PI * (2 * Math.atan(Math.exp(lat * Math.PI / 180)) - Math.PI / 2);
    }
    return {lon: lon, lat: lat};
}

function setCenter(lon, lat)
{
    var lonLat = getNormalizedLonLat(lon, lat);
    web_view1.evaluateJavaScript("g_waze_map.map.setCenter(new OpenLayers.LonLat('" + lonLat.lon + "','" + lonLat.lat + "'));");
}

function setZoom(zoom)
{
    web_view1.evaluateJavaScript("g_waze_map.map.setZoom('" + zoom + "'));");
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
    var lonLat = getNormalizedLonLat(lon, lat);
    setCenter(lonLat.lon,lonLat.lat);
    settings.lastKnownPosition = {lon:lon, lat:lat};
    console.log("TODO - add landmark");
}

function showMe(shouldCenter, shouldZoom)
{
    mapView.previousGpsLocation = mapView.currentGpsLocation;
    mapView.currentGpsLocation = {lon:gpsData.position.coordinate.longitude, lat: gpsData.position.coordinate.latitude};

    var lonLat = getNormalizedLonLat(mapView.currentGpsLocation.lon, mapView.currentGpsLocation.lat);
    web_view1.evaluateJavaScript("markMyLocation("+lonLat.lon+","+lonLat.lat+");");

    if (followMe.isSelected || shouldCenter)
    {
        console.log("center");
        setCenter(lonLat.lon, lonLat.lat);
        settings.lastKnownPosition = mapView.currentGpsLocation;
    }

    if (followMe.isSelected || shouldZoom)
    {
         console.log("zoom");
        zoomInToMax();
    }
}

var errorCount = 0;
function navigate()
{
    // TODO - comment mock data
//        gpsData.reset();
//        for (var coordKey in mapView.navigationInfo.coords)
//            gpsData.model.append({longitude: mapView.navigationInfo.coords[coordKey].x,
//                                latitude: mapView.navigationInfo.coords[coordKey].y});
        // end of mock data

    errorCount = 0;
    clearMarkersAndRoute();

    mapView.currentCoordIndex = 0;
    mapView.currentSegmentsInfoIndex = 0;

    setCenter(mapView.navigationInfo.coords[0].x, mapView.navigationInfo.coords[0].y);
    zoomInToMax();

    var coordsJSON = JSON.stringify(mapView.navigationInfo.coords);

    console.log(coordsJSON);
    web_view1.evaluateJavaScript("plotCourse("+coordsJSON+");");

    mapView.state = "NavigateState";
    currentInstruction.sectionData = mapView.navigationInfo.results[0];

    locationUpdater.start();
}

function syncLocation()
{
    var currentCoordIndex = mapView.currentCoordIndex;
    var currentSegmentsInfoIndex = mapView.currentSegmentsInfoIndex;

    var onTrack = false;
    var trimOccured = false;

    var coords = mapView.navigationInfo.coords;
    var segmentsInfo = mapView.navigationInfo.results;

    showMe();
    if (segmentsInfo.length-1 == currentSegmentsInfoIndex)
    {
        return;
    }

    for (var coordsIndex=0; onTrack == false && coordsIndex < 50 && coordsIndex+currentCoordIndex < coords.length; coordsIndex++)
    {
        if (coordsIndex + 1 + currentCoordIndex < coords.length &&
            isOnTrack({x:mapView.currentGpsLocation.lon, y:mapView.currentGpsLocation.lat},
                       coords[coordsIndex+currentCoordIndex],
                       coords[coordsIndex + 1 +currentCoordIndex]))
        {
            if (coordsIndex > 0)
            { 
                for (var searchIndex = 0; searchIndex < coordsIndex; searchIndex++)
                {
                    if (coords[currentCoordIndex+searchIndex].x == segmentsInfo[currentSegmentsInfoIndex+1].path.x &&
                        coords[currentCoordIndex+searchIndex].y == segmentsInfo[currentSegmentsInfoIndex+1].path.y )
                    {
                        currentSegmentsInfoIndex++;
                        mapView.currentSegmentsInfoIndex = currentSegmentsInfoIndex;
                        trimOccured = true;
                    }
                }
                currentCoordIndex += coordsIndex;
                mapView.currentCoordIndex = currentCoordIndex;
           }

            errorCount = 0;
            onTrack = true;
        }
    }

    if (onTrack && trimOccured)
    {
        currentInstruction.sectionData = segmentsInfo[currentSegmentsInfoIndex];
    }
    else if (!onTrack)
    {
        if (errorCount < 5)
        {
            errorCount++;
        }
        else
        {
            // TODO reroute
            console.log("need reroute - stopping navigation!!!");
            //stopNavigation();
        }
    }

//    gpsData.next(); //TODO - comment - for testing with mock GPS
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
    //console.log("is on track:" + rc)

    return rc &&
           Math.min(startPoint.x, endPoint.x) <= loc.x && loc.x <= Math.max(startPoint.x, endPoint.x) &&
           Math.min(startPoint.y, endPoint.y) <= loc.y && loc.y <= Math.max(startPoint.y, endPoint.y);
}

function stopNavigation()
{
    locationUpdater.stop();
    clearMarkersAndRoute();
    mapView.state = "BrowseState";
}
