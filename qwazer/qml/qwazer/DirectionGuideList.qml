import QtQuick 1.0

Rectangle {
    height: directionGuideListView.currentItem.height
    width: directionGuideListView.currentItem.width*5
    color: "#00000000"

    property alias model: directionGuideListView.model

    function shouldBeVisible(index, segmentId, instruction)
    {
        var isVisible = true;

        if (instruction.opcode == "CONTINUE" && index > 0)
        {
            isVisible = directionGuideListView.model.get(index-1).instruction.opcode !== "CONTINUE" &&
                    ( index == directionGuideListView.model.count - 1 || directionGuideListView.model.get(index+1).length > 300 );
        }
        else if (instruction.opcode.search(/ROUNDABOUT_EXIT/) === 0 && index === 1)
        {
            isVisible = false;
        }
        else
        {
            isVisible = index < 1 || directionGuideListView.model.get(index-1).segmentId !== segmentId;
        }

        return isVisible;
    }

    ListView {
        id: directionGuideListView
        anchors.fill: parent
        interactive: false
        orientation: ListView.Horizontal
        delegate: DirectionGuideControl {
            id: directionItem
            width: (directionItem.visible)? directionItem.diameter : 0
            visible: shouldBeVisible(index, segmentId, instruction)
            instructionArg: instruction.arg
            instructionOpcode: instruction.opcode
            color: (directionItem.ListView.isCurrentItem)? "#00b7ff" : "#00000000"
        }
    }
}
