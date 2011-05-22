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

function markDestination(lon, lat) {
    console.log("mark destinitaion was requested for " + lon + ":" + lat);
    console.log("TODO");
}

function markOrigin(lon, lat) {
    console.log("mark origin was requested for " + lon + ":" + lat);
    console.log("TODO");
}

function search(address) {
    console.log("search requested for address " + address);
    // overcome bug with QT and JS array
    web_view1.evaluateJavaScript("g_waze_map.find('" + address + "', searchCallback);");
}

function searchResultsReceived(results) {
    console.log("handling search results");
    mapView.searchResults(results);
}

function showLocation(lon, lat) {
    console.log("show location was requested for " + lon + ":" + lat);
    setCenter(lon,lat);
    console.log("TODO - add landmark");
}
