import QtQuick 1.0
import com.meego 1.0

Page {
    id: pathSelectionPage

    orientationLock: PageOrientation.LockLandscape

    tools: commonBackButtonToolbar

    Label {
        id: pathSelectionLabel
        text: translator.translate("Choose course") + translator.forceTranslate
        font.pointSize: 24
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
    }

    Rectangle {
        id: resultsRect
        color: "#ffffff"
        border.color: "#000000"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: pathSelectionLabel.bottom
        anchors.bottom: parent.bottom
        radius: 10

        anchors.margins: 10

        ListView {
            id: pathList
            anchors.fill: parent
            clip: true
            delegate: Rectangle {
                id: row
                border.color: "black"
                border.width: 2
                radius: 10
                width: col.width
                height: col.height

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: "gray"
                    }
                    GradientStop {
                        position: 1.0
                        color: "lightGray"
                    }
                }


                Column {
                    id: col
                    anchors.margins: 10
                    spacing: 10
                    Label {
                        text: (response)? translator.translate("Through %1", response.routeName) + translator.forceTranslate : ""
                        width: pathList.width
                    }
                    Label {
                        text: (response)? translator.translate("Distance is %1km", response.totalDistance/1000) + translator.forceTranslate : ""
                        width: pathList.width
                    }
                    Label {
                        text: (response)? (translator.translate("Estimated time is %1:%2 minutes", Math.floor(response.totalTime/60), ((response.totalTime%60 > 9)? response.totalTime%60 : "0" + response.totalTime%60)) + translator.forceTranslate) : ""
                        width: pathList.width
                    }
                }
                MouseArea {
                    anchors.fill: row
                    onClicked: appWindow.pageStack.push(coursePlottingBusyPage, {course: response}, true);
                }
            }
            model: courseResultsModel.dataModel
        }
    }

    BusyPage {
        id: coursePlottingBusyPage
        text: translator.translate("Plotting course%1", "...") + translator.forceTranslate
        backIcon: ""
        onBackClicked: {}

        property variant course
        onCourseChanged: delayedWorker.running = true

        Timer {
            id: delayedWorker
            interval: 1000
            onTriggered: {
                appWindow.pageStack.pop(null, true);
                mainPage.navigate(coursePlottingBusyPage.course);
            }
            repeat: false
        }
    }
}
