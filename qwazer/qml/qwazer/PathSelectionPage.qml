import QtQuick 1.0
import com.meego 1.0
import ".."

Page {
    id: pathSelectionPage
    tools: commonBackButtonToolbar

    Rectangle {
        id: resultsRect
        color: "#00000000"
        radius: 10
        anchors.fill: parent
        border.color: "#000000"

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
                    onClicked: {
                        appWindow.pageStack.push(coursePlottingBusyPage, null, true);
                        mainPage.navigate(response);
                        appWindow.pageStack.pop(null);
                    }
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
    }
}
