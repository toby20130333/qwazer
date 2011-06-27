import QtQuick 1.0
import QtMobility.location 1.1

Rectangle {
    id: mainView
    width: 800
    height: 400

    QwazerSettings {
        id: settings
        visible: false
        onSettingsLoaded: {
            settings.visible = isFirstRun;
            if (!isFirstRun)
            {
                mainView.state =  "MapState";
                map1.initialize();
            }
        }

        onOkClicked: {
            console.log("ok clicked");
            mainView.state = 'MapState';
            map1.state = "BrowseState";
            map1.initialize();
        }
    }

    Component.onCompleted: settings.initialize()

    PositionSource {
        id: positionSource
        active: true
        //nmeaSource: "nmealog.txt"
    }

//    QtObject {
//        // track mockup
//        id: positionSource
//        property int index: 0
//        property variant position : QtObject {
//            property bool longitudeValid : true
//            property bool latitudeValid : true
//            property bool verticalAccuracyValid : true
//            property bool horizontalAccuracyValid : true
//            property int verticalAccuracy : 0
//            property int horizontalAccuracy : 0
//            property variant coordinate : QtObject {
//                property double latitude: 33.21373
//                property double longitude: 35.57280
//            }
//        }

//        function next()
//        {
//            index++;
//            position.coordinate.longitude = model.get(index).longitude;
//            position.coordinate.latitude = model.get(index).latitude;
//        }

//        function reset()
//        {
//            model.clear();
//            index = 0;
//        }

//        property variant model : ListModel {}
//    }

    QwazerMap {
        id: map1
        x: 0
        y: 0

        anchors.fill: parent

        visible: false

        settings: settings

        gpsData: positionSource

        onMapLoaded: {
            mainView.state = 'MapState';
        }

        onSearchButtonClicked: {
            mainView.state = 'SearchState';
        }

        onNavigateButtonClicked: {
            mainView.state = 'NavigateState';
        }
    }

    Search {
        id: search1
        x: 0
        y: 0
        visible: false
        anchors.fill: parent

        onBackButtonPressed: {
            mainView.state = 'MapState';
        }

        onAddressSelected: {
            map1.showLocation(address.lon, address.lat);
            mainView.state = 'MapState';
        }
    }

    Search {
        id: navigate1
        x: 0
        y: 0
        visible: false
        anchors.fill: parent

        onBackButtonPressed: {
            mainView.state = 'MapState';
        }

        onAddressSelected: {
            mainView.state = 'PathSelectionState';
            pathSelection1.fromToPoints = {from:{lon: positionSource.position.coordinate.longitude, lat: positionSource.position.coordinate.latitude},
                                           to:{lon: address.lon, lat: address.lat}};
        }
    }

    PathSelection {
        id: pathSelection1
        anchors.fill: parent
        visible: false

        onBackButtonPressed: {
            mainView.state = 'NavigateState';
        }

        onPathSelected: {
             mainView.state = 'MapState';
             map1.navigationInfo = route;
        }
    }

    states: [
        State {
            name: "MapState"

            PropertyChanges {
                target: map1
                visible: true
            }
            PropertyChanges {
                 target: search1
                 visible: false
            }
            PropertyChanges {
                target: navigate1
                visible: false
            }
            PropertyChanges {
                target: pathSelection1
                visible: false
            }
        },
        State {
            name: "SearchState"

            PropertyChanges {
                target: map1
                visible: false
            }
            PropertyChanges {
                target: search1
                visible: true
            }
            PropertyChanges {
                target: navigate1
                visible: false
            }
            PropertyChanges {
                target: pathSelection1
                visible: false
            }
        },
        State {
            name: "NavigateState"

            PropertyChanges {
                target: map1
                visible: false
            }
            PropertyChanges {
                target: search1
                visible: false
            }
            PropertyChanges {
                target: navigate1
                visible: true
            }
            PropertyChanges {
                target: pathSelection1
                visible: false
            }
        },
        State {
            name: "PathSelectionState"

            PropertyChanges {
                target: map1
                visible: false
            }
            PropertyChanges {
                target: search1
                visible: false
            }
            PropertyChanges {
                target: navigate1
                visible: false
            }
            PropertyChanges {
                target: pathSelection1
                visible: true
            }
        }
    ]
}
