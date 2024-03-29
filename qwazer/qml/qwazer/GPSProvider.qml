import QtQuick 1.0
import QtMobility.location 1.1

Item {
    id: gps
    property alias positionSource: gpsData

    property int updateInterval: 2000

    PositionSource {
       id: gpsData
       active: true
       //nmeaSource: "nmealog.txt"
       updateInterval: gps.updateInterval
    }

//    QtObject {
//        // track mockup
//        id: fakeGpsData

//        signal positionChanged

//        property int updateInterval : gps.updateInterval
//        property bool isFakeData: true
//        property bool active: true
//        property int index: 0
//        property int count: 0
//        property variant position : QtObject {
//            property bool longitudeValid : true
//            property bool latitudeValid : true
//            property bool verticalAccuracyValid : true
//            property bool horizontalAccuracyValid : true
//            property int verticalAccuracy : 0
//            property int horizontalAccuracy : 0
//            property variant coordinate : QtObject {
////                property double latitude: 40.78196 // US
////                property double longitude: -73.96731 // US
////                property double latitude: 33.21373 // Israel
////                property double longitude: 35.57280 // Israel
//                property double latitude:33.212863827520735
//                property double longitude:35.567915068663496
//            }
//        }

//        function next()
//        {
//            if (count > model.count)
//            {
//                fakeGpsData.modelChanged();
//            }
//            index++;

//            var coord = model.get(index);
//            if (typeof(coord) != "undefined")
//            {
//                position.coordinate.longitude = model.get(index).path.x;
//                position.coordinate.latitude = model.get(index).path.y;
//            }
//        }

//        property variant model : ListModel {}
//        onModelChanged: {
//            count = model.count;
//            index = 0;
//        }
//    }

//    Timer {
//        id: locationUpdater
//        interval: gps.updateInterval
//        running: fakeGpsData.active
//        repeat: true
//        onTriggered: {
//            if (running)
//            {
//                fakeGpsData.next();
//                fakeGpsData.positionChanged();
//            }
//        }
//    }
}
