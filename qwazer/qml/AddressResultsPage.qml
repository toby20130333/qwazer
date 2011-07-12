import QtQuick 1.0
import com.meego 1.0

Page {
    id: addressResults

    Rectangle {
        id: resultsRect
        color: "#ffffff"
        radius: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        border.color: "#000000"
        anchors.top: inputRect.bottom
        anchors.bottom: pageContent.bottom
        anchors.right: pageContent.right
        anchors.rightMargin: 10
        anchors.left: pageContent.left
        anchors.leftMargin: 10
        clip: true

        ListView {
            model: findAddressModel.dataModel
            delegate: Item {
                Button {
                    text: name
                    onClicked: appWindow.pageStack.push(addressDetailsPage, settings.findItem(findAddressModel.dataModel, {name: name}, "name"))
                }
            }
        }
    }

}
