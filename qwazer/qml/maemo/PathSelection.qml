import QtQuick 1.0
import "../qwazer/js/Images.js" as Images

Page {
    id: pathSelection

    signal backButtonClicked

    tools: VisualItemModel {
        Flow {
            id: pathSelectionToolBarButtons
            anchors.margins: 20
            spacing: 20
            IconButton {
                text: translator.translate("Back") + translator.forceTranslate
                iconSource: Images.back
                onClicked: pathSelection.backButtonClicked()
            }
        }
    }

    ListModel {
        id: pathListModel
    }

    content: VisualItemModel {
        Rectangle {
            anchors.fill: parent

            Text {
                id: pathSelectionLabel
                text: translator.translate("Choose course") + translator.forceTranslate
                font.pointSize: 24
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10
            }

            Rectangle {
                id: rectangle2
                color: "#ffffff"
                border.color: "#000000"
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.top: pathSelectionLabel.bottom
                anchors.bottom: parent.bottom

                anchors.rightMargin: 10
                anchors.leftMargin: 10
                anchors.topMargin: 10
                anchors.bottomMargin: 10

                ListView {
                    id: pathList
                    anchors.fill: parent
                    clip: true
                    boundsBehavior: ListView.StopAtBounds
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
                            onClicked: coursePlottingBusyPage.course = response;
                        }
                    }
                    model: courseResultsModel.dataModel
                }
            }
        }
    }
}
