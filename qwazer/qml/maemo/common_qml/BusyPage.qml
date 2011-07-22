import QtQuick 1.0

Page {
    id: busyPage
    toolbarLeftItems: VisualItemModel {}

    Text {
        id: busySign
        anchors.fill: busyPage.content
        text: "-------------"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        transitions: Transition {
             RotationAnimation { duration: 1000; direction: RotationAnimation.Counterclockwise }
         }
    }
}
