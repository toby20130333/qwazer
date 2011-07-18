import QtQuick 1.0
import "../"

Item {
    signal loadDone

    property bool cancelled: false

    // {from:{lon: ,lat:}, to:{lon: ,lat:}}
    property variant fromToPoints
    onFromToPointsChanged: {
        cancelled = false;
        appWindow.pageStack.push(loadingResultsPage, null, true);

        // clear previous results
        model.clear();

        var data={from:"x:"+fromToPoints.from.lon+" y:"+fromToPoints.from.lat+" bd:true",to:"x:"+fromToPoints.to.lon+" y:"+fromToPoints.to.lat+" bd:true",returnJSON:true,returnInstructions:true,returnGeometries:true,timeout:60000,nPaths:2};
        var url = settings.country.ws_url + "/RoutingManager/routingRequest?" + serialize(data);
        console.log("requesting: " + url);
        var http_request = new XMLHttpRequest();
        http_request.open("GET", url, true);
        http_request.onreadystatechange = function () {
            var done = 4, ok = 200;
            if (cancelled) return;
            if (http_request.readyState == done && http_request.status == ok) {
                // console.log(http_request.responseText);
                var a= eval('(' + http_request.responseText + ')'); // not using JSON.parse because of crash
                for (var b in a.alternatives) {
                    if (cancelled) return;
                    var o = a.alternatives[b];
                    console.log("appending track that goes through: " + o.response.routeName);

                    var totalTime = 0;
                    var totalDistance = 0;
                    for (var key in o.response.results) {
                        if (cancelled) return;
                        var pathElement = o.response.results[key];
                        totalTime += pathElement.crossTime;
                        totalDistance += pathElement.length;
                        pathElement.streetName = o.response.streetNames[pathElement.street];
                    }

                    o.response.totalTime = totalTime;
                    o.response.totalDistance = totalDistance;
                    o.response.coords = o.coords;

                   dataModel.append({response: o.response});
                }

                appWindow.pageStack.pop(undefined, true);
                loadDone();
            }
            else
            {
                if (cancelled) return;
            }
        };
        if (cancelled) {
            appWindow.pageStack.pop(undefined, undefined, true);
            return;
        }
        http_request.send(null);
    }

    function serialize (obj) {
      var str = [];
      for(var p in obj)
         str.push(p + "=" + encodeURIComponent(obj[p]));
      return str.join("&");
    }

    property ListModel dataModel: ListModel {
                                        id: model

                                        signal loadCompleted()
                                    }


    BusyPage {
        id: loadingResultsPage

        text: translator.translate("Calculating Course%1", "...") + translator.forceTranslate

        onBackClicked: {
            cancelled = true;
            appWindow.pageStack.pop(undefined, true);
        }
    }
}
