import QtQuick 1.0
//import QtMobility.location 1.1

Item {
    id: gps
    property alias positionSource: fakeGpsData

//    PositionSource {
//        id: gpsData
//        active: true
//        //nmeaSource: "nmealog.txt"
//    }

    QtObject {
        // track mockup
        id: fakeGpsData
        property bool isFakeData: true
        property int index: 0
        property variant position : QtObject {
            property bool longitudeValid : true
            property bool latitudeValid : true
            property bool verticalAccuracyValid : true
            property bool horizontalAccuracyValid : true
            property int verticalAccuracy : 0
            property int horizontalAccuracy : 0
            property variant coordinate : QtObject {
//                property double latitude: 40.78196 // US
//                property double longitude: -73.96731 // US
                property double latitude: 33.21373 // Israel
                property double longitude: 35.57280 // Israel
            }
        }

        function next()
        {
            if (index < model.count - 1)
            {
                index++;
            }
            position.coordinate.longitude = model.get(index).longitude;
            position.coordinate.latitude = model.get(index).latitude;
        }

        function reset()
        {
            model.clear();
            index = 0;
        }

        property variant model : ListModel {}
    }

}
