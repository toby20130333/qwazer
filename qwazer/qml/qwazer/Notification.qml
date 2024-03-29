import QtQuick 1.0

Rectangle {
    id: notification
    anchors.horizontalCenter: parent.horizontalCenter
    width: 200
    height: 50
    color: "#00000000"
    smooth: true
    property bool active

    property alias text: messageText.text

    Rectangle {
        id: message
        radius: 10
        smooth: true
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#313131"
            }

            GradientStop {
                position: 0.96
                color: "#c4c4c4"
            }
        }
        border.color: "#000000"
        opacity: 1
        z: 1
        anchors.rightMargin: 5
        anchors.leftMargin: 0
        anchors.bottomMargin: 5
        anchors.topMargin: 0
        anchors.fill: parent

        Text {
            id: messageText
            x: -39
            y: 58
            text: ""
            horizontalAlignment: "AlignHCenter"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.left: parent.left
            font.pixelSize: 18
        }
    }

    Rectangle {
        id: shade
        smooth: true
        color: "#000000"
        radius: message.radius
        opacity: 0.2
        z: -1
        anchors.leftMargin: 5
        anchors.topMargin: 5
        anchors.fill: parent
    }

    states: [
        State {
            name: "ActiveState"
            when: notification.active

            PropertyChanges {
                target: notification
                y: 0
            }
        },
        State {
            name: "NonActiveState"
            when: !notification.active
            PropertyChanges {
                target: notification
                y: -notification.height
            }
        }
    ]

    transitions: [
        Transition {
            from: "ActiveState"
            to: "NonActiveState"

            NumberAnimation {
                target: notification
                property: "y"
                easing.type: Easing.OutQuad
                duration: 1000
            }
        },
        Transition {
            from: "NonActiveState"
            to: "ActiveState"

            NumberAnimation {
                target: notification
                property: "y"
                easing.type: Easing.InQuad
                duration: 1000;
            }
        }
    ]
}
