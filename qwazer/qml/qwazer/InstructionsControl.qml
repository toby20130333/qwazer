import QtQuick 1.0

Rectangle {
    id: instructionsControl

    property int length
    property int instructionArg
    property string instructionOpcode
    property string streetName
    state: instructionOpcode

    border.color: "black"

    width: Math.max(instructionImage.width, sectionLengthText.width, instructionText.width, streetNameText.width)
    height: instructionImage.height + sectionLengthText.height + instructionText.height + streetNameText.height

    Rectangle {
        id: instructionImage
        width: circle.width
        height: circle.height
        color: "#00b7ff"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: sectionLengthText.top
        border.color: "#000000"


        Image {
            id: circle
            anchors.centerIn: parent
            source: "images/circle.png"
        }

        Image {
            id: arrow
            anchors.centerIn: parent
            visible: true
            smooth: false
            source: "images/arrow.png"
        }

        Text {
            id: instructionArgText
            text: instructionArg
            visible: instructionArg !== 0;
            font.bold: true
            font.pointSize: 21
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
        }

    }

    Text {
        id: sectionLengthText
        text: ((length < 1000)? translator.translate("In %1m", length) :
                               translator.translate("In %1km", length)) + translator.forceTranslate
        anchors.horizontalCenter: parent.horizontalCenter
        wrapMode: Text.WordWrap
        anchors.bottom: instructionText.top
        font.pointSize: 18
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Text {
        id: instructionText
        text: ""
        anchors.horizontalCenter: parent.horizontalCenter
        wrapMode: Text.WordWrap
        anchors.bottom: streetNameText.top
        font.pointSize: 18
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Text {
        id: streetNameText
        text: streetName
        anchors.bottom: parent.bottom
        wrapMode: Text.WordWrap
        font.pointSize: 18
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    states: [
        State {
            name: "TURN_LEFT"

            PropertyChanges {
                target: circle
                visible: false
            }

            PropertyChanges {
                target: arrow
                rotation: 270
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Turn Left") + translator.forceTranslate
            }
        },
        State {
            name: "TURN_RIGHT"

            PropertyChanges {
                target: circle
                visible: false
            }

            PropertyChanges {
                target: arrow
                rotation: 90
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Turn Right") + translator.forceTranslate
            }
        },
        State {
            name: "CONTINUE"

            PropertyChanges {
                target: arrow
                visible: true
            }

            PropertyChanges {
                target: circle
                visible: false
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Continue") + translator.forceTranslate
            }
        },
        State {
            name: "KEEP_RIGHT"

            PropertyChanges {
                target: circle
                visible: false
            }

            PropertyChanges {
                target: arrow
                rotation: 135
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Keep To The Right") + translator.forceTranslate
            }
        },
        State {
            name: "KEEP_LEFT"

            PropertyChanges {
                target: circle
                visible: false
            }

            PropertyChanges {
                target: arrow
                rotation: 225
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Keep To The Left") + translator.forceTranslate
            }
        },
        State {
            name: "ROUNDABOUT_ENTER"

            PropertyChanges {
                target: arrow
                visible: false
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Roundabout Exit At %1", instructionArg.text) + translator.forceTranslate
            }
        },
        State {
            name: "ROUNDABOUT_EXIT"

            PropertyChanges {
                target: arrow
                visible: false
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Roundabout Exit At %1", instructionArg.text) + translator.forceTranslate
            }
        },
        State {
            name: "ROUNDABOUT_RIGHT"
            PropertyChanges {
                target: arrow
                rotation: 90
                visible: true
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Right At Roundabout") + translator.forceTranslate
            }
        },
        State {
            name: "ROUNDABOUT_EXIT_RIGHT"
            PropertyChanges {
                target: arrow
                rotation: 90
                visible: true
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Right At Roundabout") + translator.forceTranslate
            }
        },
        State {
            name: "ROUNDABOUT_LEFT"
            PropertyChanges {
                target: arrow
                visible: true
                rotation: 270
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Left At Roundabout") + translator.forceTranslate
            }
        },
        State {
            name: "ROUNDABOUT_EXIT_LEFT"
            PropertyChanges {
                target: arrow
                visible: true
                rotation: 270
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Left At Roundabout") + translator.forceTranslate
            }
        },
        State {
            name: "ROUNDABOUT_STRAIGHT"
            PropertyChanges {
                target: arrow
                visible: true
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Stright At Roundabout") + translator.forceTranslate
            }
        },
        State {
            name: "ROUNDABOUT_EXIT_STRAIGHT"
            PropertyChanges {
                target: arrow
                visible: true
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Stright At Roundabout") + translator.forceTranslate
            }
        },
        State {
            name: "APPROACHING_DESTINATION"
            PropertyChanges {
                target: instructionArgText
                text: "TODO"
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Approaching Destination") + translator.forceTranslate
            }
        }
    ]

}
