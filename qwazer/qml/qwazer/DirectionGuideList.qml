import QtQuick 1.0

Rectangle {
    height: directionGuideListView.currentItem.height
    width: directionGuideListView.currentItem.width*5
    property alias model: directionGuideListView.model

    ListView {
        id: directionGuideListView
        anchors.fill: parent
        interactive: false
        orientation: ListView.Horizontal
        delegate: DirectionGuideControl {
            id: directionItem
            instructionArg: instruction.arg
            instructionOpcode: instruction.opcode
            color: (directionItem.ListView.isCurrentItem)? "#00b7ff" : "#00000000"
        }
    }
}
