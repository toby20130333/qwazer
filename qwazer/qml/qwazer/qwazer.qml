import QtQuick 1.0

Rectangle {
    id: mainView
    width: 800
    height: 400

    Map {
        id: map1
        x: 0
        y: 0
        visible: false
        onMapLoaded: mainView.state = 'MapState'
        onSearchButtonClicked: mainView.state = 'SearchState'
//        onNavigateButtonClicked: mainView.state = 'NavigateState'
    }

    Search {
        id: search1
        x: 0
        y: 0
        visible: false
        onBackButtonPressed: mainView.state = 'MapState'

        onAddressSelected: map1.showLocation(address.lon, address.lat)
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
        }
    ]
}
