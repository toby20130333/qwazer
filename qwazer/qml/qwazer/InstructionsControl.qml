import QtQuick 1.0

Rectangle {
    id: instructionsControl
    width: 150
    height: 150

    property variant sectionData

    onSectionDataChanged: {
        console.log("updating segment: " + JSON.stringify(sectionData));
        if (sectionData.length < 1000)
        {
            sectionLengthText.text = translator.translate("In %1m", sectionData.length);
        }
        else
        {
            sectionLengthText.text = translator.translate("In %1km", sectionData.length);
        }
        instructionText.text = sectionData.instruction.opcode + " " + sectionData.instruction.arg;
        instructionsControl.state = sectionData.instruction.opcode;
        instructionArg.text = sectionData.instruction.arg;
        instructionArg.visible = sectionData.instruction.arg !== 0;
        var streetName = sectionData.streetName;
        streetNameText.text = (streetName!==null)? streetName : "";
    }

    Rectangle {
        id: instructionImage
        color: "#00b7ff"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: sectionLengthText.top
        anchors.top: parent.top
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
            id: instructionArg
            text: ""
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
            font.pixelSize: 21
        }

    }

    Text {
        id: sectionLengthText
        text: ""
        anchors.left: parent.left
        anchors.right: parent.right
        wrapMode: Text.WordWrap
        anchors.bottom: instructionText.top
        font.pointSize: 18
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Text {
        id: instructionText
        text: ""
        anchors.left: parent.left
        anchors.right: parent.right
        wrapMode: Text.WordWrap
        anchors.bottom: streetNameText.top
        font.pointSize: 18
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Text {
        id: streetNameText
        text: ""
        anchors.left: parent.left
        anchors.right: parent.right
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
                target: instructionArg
                text: "TODO"
            }

            PropertyChanges {
                target: instructionText
                text: translator.translate("Approaching Destination") + translator.forceTranslate
            }
        }
    ]

}
