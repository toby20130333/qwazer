import QtQuick 1.0

Rectangle {
    height: directionGuideListView.currentItem.height
    width: directionGuideListView.currentItem.width*5
    color: "#00000000"

    property alias model: directionGuideListView.model

    ListView {
        id: directionGuideListView
        anchors.fill: parent
        interactive: false
        orientation: ListView.Horizontal
        delegate: DirectionGuideControl {
            id: directionItem
            width: (directionItem.visible)? directionItem.diameter : 0
            visible: (typeof(instruction) == "undefined" || (instruction.opcode == "CONTINUE" && index > 0))?
                        directionGuideListView.model.get(index-1).instruction.opcode !== "CONTINUE" :
                        index < 1 || directionGuideListView.model.get(index-1).segmentId !== directionGuideListView.model.get(index).segmentId
            instructionArg: (typeof(instruction) != "undefined")? instruction.arg : 0
            instructionOpcode: (typeof(instruction) != "undefined")? instruction.opcode : ""
            color: (directionItem.ListView.isCurrentItem)? "#00b7ff" : "#00000000"
        }
    }
}
