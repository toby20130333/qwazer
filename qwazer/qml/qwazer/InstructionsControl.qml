import QtQuick 1.0

Rectangle {
    id: rectangle1
    width: 150
    height: 150

    property variant sectionData

    onSectionDataChanged: {
        if (sectionData.length < 1000)
        {
            sectionLengthText.text = "בעוד " + sectionData.length + " מטרים";
        }
        else
        {
            sectionLengthText.text = "בעוד " + sectionData.length + ' ק"מ';
        }
        instructionText.text = sectionData.instruction.opcode + " " + sectionData.instruction.arg;
        streetNameText.text = sectionData.streetName;
    }

    Image {
        id: instructionImage
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 0
    }

    Text {
        id: sectionLengthText
        text: ""
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: instructionImage.bottom
        font.pointSize: 20
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Text {
        id: instructionText
        text: ""
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: sectionLengthText.bottom
        font.pointSize: 20
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Text {
        id: streetNameText
        text: ""
        wrapMode: Text.WordWrap
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: instructionText.bottom
        font.pointSize: 20
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

}
