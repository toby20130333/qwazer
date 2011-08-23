import QtQuick 1.0

Rectangle {
    id: instructionImage
    width: diameter
    height: diameter
    smooth: true

    color: "#00b7ff"
    border.color: "#000000"

    property string text
    property int instructionArg
    property string instructionOpcode
    property int diameter: 56

    state: instructionOpcode

    Image {
        id: circle
        anchors.centerIn: parent
        width: diameter
        height: diameter
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "images/circle.png"
    }

    Image {
        id: arrow
        anchors.centerIn: parent
        width: diameter
        height: diameter
        fillMode: Image.PreserveAspectFit
        smooth: true
        visible: true
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
                target: instructionImage
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
                target: instructionImage
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
                target: instructionImage
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
                target: instructionImage
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
                target: instructionImage
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
                target: circle
                visible: true
            }

            PropertyChanges {
                target: instructionImage
                text: translator.translate("Roundabout Exit At %1", instructionArg) + translator.forceTranslate
            }
        },
        State {
            name: "ROUNDABOUT_EXIT"

            PropertyChanges {
                target: arrow
                visible: false
            }

            PropertyChanges {
                target: circle
                visible: true
            }

            PropertyChanges {
                target: instructionImage
                text: translator.translate("Roundabout Exit At %1", instructionArg) + translator.forceTranslate
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
                target: circle
                visible: true
            }

            PropertyChanges {
                target: instructionImage
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
                target: circle
                visible: true
            }

            PropertyChanges {
                target: instructionImage
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
                target: circle
                visible: true
            }

            PropertyChanges {
                target: instructionImage
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
                target: circle
                visible: true
            }

            PropertyChanges {
                target: instructionImage
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
                target: circle
                visible: true
            }

            PropertyChanges {
                target: instructionImage
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
                target: circle
                visible: true
            }

            PropertyChanges {
                target: instructionImage
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
                target: instructionImage
                text: translator.translate("Approaching Destination") + translator.forceTranslate
            }
        }
    ]
}
