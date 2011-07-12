import QtQuick 1.0
import com.meego 1.0

Page {
    id:searchAddressPage

    tools: ToolBarLayout {
        ToolIcon { id: backButton; anchors.verticalCenterOffset: 0; anchors.leftMargin: 10; iconId: "toolbar-back"; platformIconId: "toolbar-back"
            anchors.right: parent===undefined ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    TextField {
        id: addressField
        height: 50
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
    }

    Button {
        id: searchButton
        anchors.left: addressField.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.right: parent.right
    }
}
