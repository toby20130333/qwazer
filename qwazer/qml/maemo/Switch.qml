import QtQuick 1.0

Rectangle {
    id: toggleButton
    width: 130
    height: 40
    radius: Math.floor(height/2)
    color: "#00000000"

    property bool checked: false
    property int endLocation: width - height - 2

    function toggle() {
        if (toggleButton.state == "on")
            toggleButton.state = "off";
        else
            toggleButton.state = "on";
    }

    function releaseSwitch() {
        if (selector.x == 5) {
            if (toggleButton.state == "off") return;
        }
        if (selector.x == endLocation) {
            if (toggleButton.state == "on") return;
        }
        toggle();
    }

    Rectangle {
        id: buttonRow
        width: parent.width
        height: parent.height
        color: "#00000000"

        Rectangle {
            id: rightEnder
            width: toggleButton.height
            height: toggleButton.height
            radius: toggleButton.radius
            border.color: "#000000"
            anchors.right: parent.right
        }

        Rectangle {
            id: leftEnder
            width: toggleButton.height
            height: toggleButton.height
            radius: toggleButton.radius
            border.color: "#000000"
            anchors.left: parent.left
        }
        Rectangle {
            id: midArea
            anchors.rightMargin: rightEnder.radius
            anchors.leftMargin: leftEnder.radius
            anchors.fill: parent
        }
    }

    MouseArea {
        id: mousearea1
        drag.axis: Drag.XAxis
        anchors.fill: parent
        drag.target: selector;
        drag.minimumX: 5;
        drag.maximumX: endLocation
        onClicked: toggle()
        onReleased: releaseSwitch()
    }

    Rectangle {
        id: upperLine
        width: parent.width - rightEnder.width - 2
        height: 1
        color: "transparent"
        border.color: "black"
        z: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: -1
    }

    Rectangle {
        id: underLine
        width: parent.width - rightEnder.width - 2
        height: 1
        color: "transparent"
        border.color: "black"
        z: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -1
    }

    Rectangle {
        id: selector
        anchors.verticalCenter: toggleButton.verticalCenter
        width: toggleButton.height-5
        height: toggleButton.height-5
        color: "#000000"
        radius: toggleButton.height-5
    }

    states: [
        State {
            name: "on"
            when: checked
            PropertyChanges { target: selector; x: endLocation }
            PropertyChanges { target: toggleButton; checked: true }
            PropertyChanges { target: midArea; color: "#2e7dea" }
            PropertyChanges { target: leftEnder; color: "#2e7dea" }
            PropertyChanges { target: rightEnder; color: "#2e7dea" }
        },
        State {
            name: "off"
            when: !checked
            PropertyChanges { target: selector; x: 5 }
            PropertyChanges { target: toggleButton; checked: false }
            PropertyChanges { target: midArea; color: "#ffffff" }
            PropertyChanges { target: leftEnder; color: "#ffffff" }
            PropertyChanges { target: rightEnder; color: "#ffffff" }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 200 }
    }

}
