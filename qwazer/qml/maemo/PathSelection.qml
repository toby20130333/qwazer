import QtQuick 1.0

Rectangle {
    id: rectangle1
    anchors.fill: parent

    signal backButtonClicked

    Text {
        id: pathSelectionLabel
        text: translator.translate("Choose course") + translator.forceTranslate
        font.pointSize: 24
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: rectangle2.right
    }

    Button {
        id: backButton
        text: translator.translate("Back") + translator.forceTranslate
        anchors.right: rectangle2.right
        anchors.left: rectangle2.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        height: 50
        onClicked: backButtonClicked()
    }

    ListModel {
        id: pathListModel
    }

    Rectangle {
        id: rectangle2
        color: "#ffffff"
        border.color: "#000000"
        anchors.bottom: backButton.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: pathSelectionLabel.bottom
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        ListView {
            id: pathList
            anchors.fill: parent
            delegate: Rectangle {
                id: row
                border.color: "black"
                radius: 10
                width: col.width
                height: col.height
                Column {
                    id: col
                    anchors.margins: 10
                    spacing: 10
                    Text {
                        text: (response)? translator.translate("Through %1", response.routeName) + translator.forceTranslate : ""
                        width: pathList.width
                    }
                    Text {
                        text: (response)? translator.translate("Distance is %1km", response.totalDistance/1000) + translator.forceTranslate : ""
                        width: pathList.width
                    }
                    Text {
                        text: (response)? (translator.translate("Estimated time is %1:%2 minutes", Math.floor(response.totalTime/60), ((response.totalTime%60 > 9)? response.totalTime%60 : "0" + response.totalTime%60)) + translator.forceTranslate) : ""
                        width: pathList.width
                    }
                }
                MouseArea {
                    anchors.fill: row
                    onClicked: qwazerMapView.navigate(response)
                }
            }
            model: courseResultsModel.dataModel
        }
    }
}
