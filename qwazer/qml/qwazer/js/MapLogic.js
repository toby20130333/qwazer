var ERROR_MARGIN = 0.0005;


function zoomIn() {
    web_view1.evaluateJavaScript("g_waze_map.map.zoomIn();");
    settings.zoom = settings.zoom + 1;
}

function zoomInToMax() {
    web_view1.evaluateJavaScript("g_waze_map.map.zoomTo("+savedMapData.maxZoom+");");
    settings.zoom = savedMapData.maxZoom;
}

function zoomOut() {
    web_view1.evaluateJavaScript("g_waze_map.map.zoomOut();");
    settings.zoom = settings.zoom - 1;
}

function getCurrentExtent() {
    return web_view1.evaluateJavaScript("g_waze_map.map.getExtent();");
}

function setCenter(lon, lat)
{
    web_view1.evaluateJavaScript("setCenter(" + lon + "," + lat + ");");
}

function setZoom(zoom)
{
    web_view1.evaluateJavaScript("g_waze_map.map.setZoom('" + zoom + "'));");
    settings.zoom = zoom;
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

function setLastKnownPosition(lon, lat)
{
    settings.lastKnownPosition = {lon:lon, lat:lat};
}

function showLocation(lon, lat)
{
    console.log("show location was requested for " + lon + ":" + lat);
    setCenter(lon, lat);
    setLastKnownPosition(lon,lat);
    console.log("TODO - add landmark");
}

function showMe(shouldCenter, shouldZoom)
{
    mapView.previousGpsLocation = mapView.currentGpsLocation;
    mapView.currentGpsLocation = {lon:gpsData.position.coordinate.longitude, lat: gpsData.position.coordinate.latitude};

    web_view1.evaluateJavaScript("markMyLocation("+mapView.currentGpsLocation.lon+","+mapView.currentGpsLocation.lat+");");

    if (isFollowMe || shouldCenter)
    {
        setCenter(mapView.currentGpsLocation.lon, mapView.currentGpsLocation.lat);
        settings.lastKnownPosition = mapView.currentGpsLocation;
    }

    if (isFollowMe || shouldZoom)
    {
        zoomInToMax();
    }
}

var errorCount = 0;
function navigate(coords)
{
    if (gpsData.isFakeData)
    {
        // auto driver for testing
        gpsData.model = mapView.navigationSegments;
    }

    errorCount = 0;
    clearMarkersAndRoute();

    setCenter(mapView.navigationSegments.get(0).x, mapView.navigationSegments.get(0).y);
    zoomInToMax();

    var coordsJSON = JSON.stringify(coords);

//    console.log(coordsJSON);
    web_view1.evaluateJavaScript("plotCourse("+coordsJSON+");");
}

var coordCount = 0;
function syncLocation()
{
    var segmentsInfo = mapView.navigationSegments;
    var currentLocation = {x:mapView.currentGpsLocation.lon, y:mapView.currentGpsLocation.lat};
    var onTrack = false;

    if (segmentsInfo.count === 0)
    {
        return;
    }

    for (var coordsIndex=0; onTrack == false && coordsIndex < 50 && coordsIndex < segmentsInfo.count; coordsIndex++)
    {
        if (coordsIndex + 1 < segmentsInfo.count &&
            isOnTrack( currentLocation,
                       segmentsInfo.get(coordsIndex).path,
                       segmentsInfo.get(coordsIndex + 1).path))
        {
            if (coordsIndex > 0)
            {
                for (var index=0; index < coordsIndex; index++)
                {
                    segmentsInfo.remove(0);
                }
            }

            errorCount = 0;
            onTrack = true;
        }
    }

    if (!onTrack)
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

function computeDistance(coord1, coord2)
{
    // thanks to http://www.movable-type.co.uk/scripts/latlong.html
    var lon1 = coord1.x * Math.PI / 180;
    var lat1 = coord1.y * Math.PI / 180;
    var lon2 = coord2.x * Math.PI / 180;
    var lat2 = coord2.y * Math.PI / 180;

    var r = 6371; // km
    var d = Math.acos(Math.sin(lat1)*Math.sin(lat2) +
                      Math.cos(lat1)*Math.cos(lat2) *
                      Math.cos(lon2-lon1)) * r;

    return (isNaN(d))? 0 : d*1000;
}

function stopNavigation()
{
    clearMarkersAndRoute();
}
