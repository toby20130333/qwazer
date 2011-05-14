import QtQuick 1.0

Rectangle {
    id: mainView
    width: 800
    height: 400

    Map {
        id: map1
        x: 288
        y: -182
        visible: false
        onMapLoaded: mainView.state = 'MapState'
    }

    states: [
        State {
            name: "MapState"

            PropertyChanges {
                target: map1
                visible: true
            }
        }
    ]
}
