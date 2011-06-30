import QtQuick 1.0

Rectangle {
    id: rectangle1
    width: 300
    height: 300

    signal backButtonPressed
    signal pathSelected(variant route)

    property string ws_url
    property variant fromToPoints

    onFromToPointsChanged: {
        // clear previous results
        pathListModel.clear();

        var data={from:"x:"+fromToPoints.from.lon+" y:"+fromToPoints.from.lat+" bd:true",to:"x:"+fromToPoints.to.lon+" y:"+fromToPoints.to.lat+" bd:true",returnJSON:true,returnInstructions:true,returnGeometries:true,timeout:60000,nPaths:2};
        var url = ws_url + "/RoutingManager/routingRequest?" + serialize(data);
        console.log("requesting: " + url);
        var http_request = new XMLHttpRequest();
        http_request.open("GET", url, true);
        http_request.onreadystatechange = function () {
          var done = 4, ok = 200;
          if (http_request.readyState == done && http_request.status == ok) {
              // console.log(http_request.responseText);
              var a= eval('(' + http_request.responseText + ')'); // not using JSON.parse because of crash
              for (var b in a.alternatives) {
                  var o = a.alternatives[b];
                  console.log("appending track that goes through: " + o.response.routeName);

                  var totalTime = 0;
                  var totalDistance = 0;
                  for (var key in o.response.results) {
                      var pathElement = o.response.results[key];
                      totalTime += pathElement.crossTime;
                      totalDistance += pathElement.length;
                      pathElement.streetName = o.response.streetNames[pathElement.street];
                  }

                  o.response.totalTime = totalTime;
                  o.response.totalDistance = totalDistance;
                  o.response.coords = o.coords;

                  pathListModel.append({response: o.response});
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

    Text {
        id: pathSelectionLabel
        text: "בחר מסלול"
        font.pointSize: 24
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: rectangle2.right
    }

    Button {
        id: backButton
        text: "חזרה"
        anchors.right: rectangle2.right
        anchors.left: rectangle2.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        height: 50
        onClicked: backButtonPressed()
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
        anchors.top: pathSelectionLabel.bottom
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        ListView {
            id: pathList
            anchors.fill: parent
            delegate: Component {
                Row {
                    spacing: 10
                    Button {
                        id: selectButton
                        text: "בחר"
                        onClicked:pathSelected(response)

                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Column {
                        Text {
                            text: "דרך " + response.routeName
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            width: pathList.width-selectButton.width-20
                        }
                        Text {
                            text: "מרחק " + response.totalDistance/1000 + ' ק"מ'
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            width: pathList.width-selectButton.width-20
                        }
                        Text {
                            text: "זמן משוער " + Math.floor(response.totalTime/60) + ":" + ((response.totalTime%60 > 9)? response.totalTime%60 : "0" + response.totalTime%60) + " דקות"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            width: pathList.width-selectButton.width-20
                        }
                    }
                }
            }
            model: pathListModel
        }
    }


}
