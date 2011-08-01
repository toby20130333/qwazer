import QtQuick 1.0

Rectangle {
    id: indicator
    width: 50
    height: 50
    color: "#00000000"

    property bool active: false

    Rectangle {
        id: ball1
        x: 18
        y: 25
        width: indicator.width/2
        height: indicator.width/2
        radius: height
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ffffff"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        border.color: "#000000"
    }

    Rectangle {
        id: ball2
        width: indicator.width/2
        height: indicator.width/2
        radius: width
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ffffff"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
        border.color: "#000000"
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
    }

    RotationAnimation
    {
        target: indicator
        property: "rotation" // Suppress a warning
        from: 0
        to: 360
        direction: RotationAnimation.Clockwise
        duration: 1000
        loops: Animation.Infinite
        running: indicator.active
    }
}
