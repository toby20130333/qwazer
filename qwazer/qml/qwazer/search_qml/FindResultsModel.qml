import QtQuick 1.0
import "../.."

Item {
    signal loadDone

    property string address
    property bool cancelled: false

    onAddressChanged: {
        cancelled = false;
        appWindow.pageStack.push(loadingResultsPage, null, true);

        // clear previous results
        model.clear();

        var data = {"q": address};
        var url = settings.country.ws_url + "/WAS/mozi?" + serialize(data);
        console.log("requesting: " + url);
        var my_JSON_object = {};
        var http_request = new XMLHttpRequest();
        http_request.open("GET", url, true);
        http_request.onreadystatechange = function () {
          var done = 4, ok = 200;
          if (cancelled) {
            appWindow.pageStack.pop();
            return;
          }
          if (http_request.readyState == done && http_request.status == ok) {
              console.log(http_request.responseText);
              var a = JSON.parse(http_request.responseText);
              for (var b in a) {
                  if (cancelled) {
                      appWindow.pageStack.pop(searchAddressPage, true);
                      return;
                  }
                  var o = a[b];
                  model.append({name: o.name, location: o.location, phone: o.phone, url: o.url, businessName: o.businessName});
              }
              appWindow.pageStack.pop(searchAddressPage, true);
              loadDone();
          }
        };
        if (cancelled) {
            appWindow.pageStack.pop(searchAddressPage, true);
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

        text: "Searching for address..."

        onBackClicked: {
            cancelled = true;
            appWindow.pageStack.pop();
        }
    }
}
