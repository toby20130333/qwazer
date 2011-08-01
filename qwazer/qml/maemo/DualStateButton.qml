import QtQuick 1.0

Rectangle {
    id: dualStateButton
    width: buttonRow.width
    height: buttonRow.height
    radius: Math.floor(height/2)
    border.color: "black"
    color: "#00000000"

    property alias rightText: rightTextLabel.text
    property alias leftText: leftTextLabel.text

    property int selectedIndex: 0

    Rectangle {
        id: buttonRow
        width: (Math.max(rightTextLabel.width, leftTextLabel.width)+height)*2
        height: Math.max(rightTextLabel.height, leftTextLabel.height)
        color: "#00000000"

        Rectangle {
            id: splitter
            x: 0
            width: 1
            color: "#000000"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
        }


        Rectangle {
            id: rightEnder
            width: dualStateButton.height
            height: dualStateButton.height
            color: "#ffffff"
            radius: dualStateButton.radius
            border.color: "#000000"
            anchors.right: parent.right
            opacity: 1
        }

        Rectangle {
            id: rightSide
            width: 200
            color: "#ffffff"
            anchors.rightMargin: dualStateButton.radius
            opacity: 1
            anchors.right: parent.right
            anchors.left: splitter.right
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0

            MouseArea {
                id: mousearea1
                anchors.fill: parent
                Text {
                    id: rightTextLabel
                    text: "right"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                    font.pointSize: 22
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                onClicked: selectedIndex = 1
            }
        }

        Rectangle {
            id: leftEnder
            width: dualStateButton.height
            height: dualStateButton.height
            color: "#ffffff"
            radius: dualStateButton.radius
            border.color: "#000000"
            anchors.left: parent.left
            anchors.leftMargin: 0
        }


        Rectangle {
            id: leftSide
            color: "#ffffff"
            anchors.leftMargin: dualStateButton.radius
            opacity: 1
            anchors.right: splitter.left
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.rightMargin: 0

            MouseArea {
                id: mousearea2
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.rightMargin: 0
                Text {
                    id: leftTextLabel
                    x: 0
                    text: "left"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                    font.pointSize: 22
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                onClicked: selectedIndex = 0
            }
        }
    }

    Rectangle {
        id: upperLine
        width: parent.width - rightEnder.width + 2
        height: 1
        color: "transparent"
        border.color: "black"
        z: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: -1
    }

    states: [
        State {
            name: "RightSelectedState"
            when: selectedIndex == 1

            PropertyChanges {
                target: rightSide
                color: "#000000"
            }

            PropertyChanges {
                target: rightEnder
                color: "#000000"
            }

            PropertyChanges {
                target: rightTextLabel
                color: "#ffffff"
            }
        },
        State {
            name: "LeftSelectedState"
            when: selectedIndex == 0

            PropertyChanges {
                target: leftEnder
                color: "#000000"
            }

            PropertyChanges {
                target: leftSide
                color: "#000000"
            }

            PropertyChanges {
                target: leftTextLabel
                color: "#ffffff"
            }
        }
    ]
}
