import QtQuick 1.0

ListItem {
    id: button
    property bool clickable: true
    signal zoom

    onClicked: if (clickable) zoom();
    radius: height
    width: height
    smooth: true

    states: [
        State {
            name: "Enabled"
            extend: ""
            when: clickable
        },
        State {
            name: "Disabled"
            extend: ""
            when: !clickable
            PropertyChanges {
                target: button
                border.color: "red"
                border.width: 5
                opacity: 0.5
            }
        }
    ]

}
