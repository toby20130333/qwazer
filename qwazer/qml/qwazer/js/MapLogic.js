function zoomIn() {
    web_view1.evaluateJavaScript("g_waze_map.map.zoomIn();");
}

function zoomOut() {
    web_view1.evaluateJavaScript("g_waze_map.map.zoomOut();");
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

function showMe()
{
    setCenter(positionSource.position.coordinate.longitude, positionSource.position.coordinate.latitude);
    console.log("TODO - repaint my location landmark");
}
