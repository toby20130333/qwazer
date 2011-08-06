import QtQuick 1.0
import com.meego 1.0
import "../qwazer"

Page {
    id: addressResults

    tools: commonBackButtonToolbar

    Label {
        id: addressResultsLabel
        text: translator.translate("Address Search Results") + translator.forceTranslate
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
        anchors.top: addressResultsLabel.bottom
        anchors.bottom: parent.bottom
        radius: 10

        anchors.margins: 10


        ListView {
            id: resultsListView
            model: findAddressModel.dataModel
            anchors.fill: resultsRect
            clip: true
            delegate: Component {
                ListItem {
                    text: name
                    width: resultsListView.width
                    onClicked: {
                        var o = findAddressModel.dataModel.get(index);
                        appWindow.pageStack.push(addressDetailsPage, {addressDetails: o});
                    }
                }
            }
        }
    }

}
