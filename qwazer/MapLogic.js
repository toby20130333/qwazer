function htmlElement() {
    return '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">' +
           '<html>' +
                '<head>' +
                        '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">'+
                        '<meta name="apple-mobile-web-app-capable" content="yes">'+
                        '<title>Test API</title>'+
                '</head>'+
                '<body>'+
                        '<div id="map" style="width:'+(web_view1.width-20)+'px;height:'+(web_view1.height-20)+'px;">\n</div>'+
                        '<script type="text/javascript">' +
                            'var results;'+
                            'function searchCallback(response) {results=response;window.qml.handleResults(response)}'+
                        '</script>' +
                        '<script type="text/javascript">' +
                            'g_waze_config = { '+
                                'div_id:"map",'+
                                'locale : "israel",'+
                                'center_lon:34.7898,'+
                                'center_lat:32.08676,'+
                                'zoom:8,'+
                                'token:"example-token",'+
                                'alt_base_layer:"israel_colors",'+
                                'alt_map_servers:"http://ymap1.waze.co.il/wms-c/",'+
                            '};'+
                        '</script>'+
                        '<script type="text/javascript" src="http://www.waze.co.il/js/WazeEmbeddedMap.js"></script>'+
                '</body>'+
        '</html>'; // for(i=0; i&lt; arr.length; i++) window.qml.addSearchResult(arr[i]) window.qml.clearSearchList(); window.qml.searchResultsReceived();
}


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
