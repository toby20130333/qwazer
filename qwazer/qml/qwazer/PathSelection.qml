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

        var data={from:"x:"+fromToPoints.from.lon+" y:"+fromToPoints.from.lat+" bd:true",to:"x:"+fromToPoints.to.lon+" y:"+fromToPoints.to.lat+" bd:true",returnJSON:true,returnInstructions:true,timeout:60000,nPaths:2};
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
              for (var b in a.alternatives) {
                  var o = a.alternatives[b];
                  console.log("appending track that goes through: " + o.response.routeName);

                  var totalTime = 0;
                  var totalDistance = 0;
                  for (var key in o.response.results) {
                      totalTime += o.response.results[key].crossTime;
                      totalDistance += o.response.results[key].length;
                  }

                  pathListModel.append({response: o.response, totalTime: totalTime, totalDistance: totalDistance});
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
                        text: "הצג"
                        onClicked: pathSelected(response);
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
                            text: "מרחק " + totalDistance/1000 + ' ק"מ'
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            width: pathList.width-selectButton.width-20
                        }
                        Text {
                            text: "זמן משוער " + Math.floor(totalTime/60) + ":" + ((totalTime%60 > 9)? totalTime%60 : "0" + totalTime%60) + " דקות"
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
