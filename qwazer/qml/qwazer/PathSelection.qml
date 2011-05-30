import QtQuick 1.0

Rectangle {
    id: rectangle1
    width: 300
    height: 300

    signal backButtonPressed
    signal pathSelected(variant path)

    property variant fromToPoints

    onFromToPointsChanged: {
        // clear previous results
        pathListModel.clear();

        var data={from:"x:"+fromToPoints.from.lon+" y:"+fromToPoints.from.lat+" bd:true",to:"x:"+fromToPoints.to.lon+" y:"+fromToPoints.to.lat+" bd:true",returnJSON:true,returnGeometries:true,returnInstructions:true,timeout:60000,nPaths:2};
        var url = "http://www.waze.co.il/RoutingManager/routingRequest?" + serialize(data);
        console.log("requesting: " + url);
        var my_JSON_object = {};
        var http_request = new XMLHttpRequest();
        http_request.open("GET", url, true);
        http_request.onreadystatechange = function () {
          var done = 4, ok = 200;
          if (http_request.readyState == done && http_request.status == ok) {
              console.log(http_request.responseText);
              var a = JSON.parse(http_request.responseText);
              for (var b in a) {
                  var o = a[b];
//                  pathListModel.append({name: o.name, lon: o.location.lon, lat: o.location.lat});
              }
          }
        };
        http_request.send(null);
    }

    function serialize (obj) {
      var str = [];
      for(var p in obj)
         str.push(p + "=" + encodeURIComponent(obj[p]));
      return str.join("&");
    }
    Button {
        id: backButton
        text: "חזרה"
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        y: 243
        height: 50
    }

    ListModel {
        id: pathListModel

    }

    Rectangle {
        id: rectangle2
        color: "#ffffff"
        border.color: "#000000"
        anchors.bottom: backButton.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        ListView {
            id: pathList
            anchors.fill: parent
        }
    }


}
