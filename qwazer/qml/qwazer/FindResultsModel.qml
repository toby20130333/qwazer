import QtQuick 1.0
import QtWebKit 1.0

Item {
    property string address

    onAddressChanged: {
        // clear previous results
        model.clear();

        var data = {"q": address};
        var url = "http://www.waze.co.il/WAS/mozi?" + serialize(data);
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
                  model.append({name: o.name, lon: o.location.lon, lat: o.location.lat});
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

    property ListModel dataModel: ListModel {
                                        id: model

                                        signal loadCompleted()

                                    }
}
