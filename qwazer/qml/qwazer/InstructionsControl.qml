import QtQuick 1.0

Rectangle {
    id: instructionsControl

    property int length
    property int instructionArg
    property string instructionOpcode
    property string streetName

    border.color: "black"

    width: Math.max(directionGuideControl.width, sectionLengthText.width, instructionText.width, streetNameText.width)
    height: directionGuideControl.height + sectionLengthText.height + instructionText.height + streetNameText.height

    DirectionGuideControl {
        id: directionGuideControl
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: sectionLengthText.top
        instructionOpcode: instructionsControl.instructionOpcode
        instructionArg: instructionsControl.instructionArg
    }

    Text {
        id: sectionLengthText
        text: ((length < 1000)? translator.translate("In %1m", length) :
                               translator.translate("In %1km", length/1000)) + translator.forceTranslate
        anchors.horizontalCenter: parent.horizontalCenter
        wrapMode: Text.WordWrap
        anchors.bottom: instructionText.top
        font.pointSize: 18
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Text {
        id: instructionText
        text: directionGuideControl.text
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

}
