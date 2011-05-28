import QtQuick 1.0
import QtWebKit 1.0

Item {
    property string address

    onAddressChanged: {
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

    ListModel {
        id: model

        signal loadCompleted()
    }
}
