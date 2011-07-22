import QtQuick 1.0

Rectangle {
    id: rectangle2
    width: 300
    height: 300

    property alias ws_url : resultsModel.ws_url

    signal selected(variant selection)

    Button {
        id: searchButton
        width: 89
        height: 50
        text: translator.translate("Search") + mainView.forceTranslate
        anchors.left: parent.left
        anchors.leftMargin: 0
        onClicked: {
            resultsModel.address = searchField.text;
        }
    }

    Rectangle {
        id: rectangle1
        height: 50
        color: "#ffffff"
        border.color: "#000000"
        anchors.left: searchButton.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 0

        TextInput {
            id: searchField
            text: ""
            anchors.fill: parent
            horizontalAlignment: TextInput.AlignRight
            font.pixelSize: 24
        }
    }

    FindResultsModel {
        id: resultsModel
    }

    Rectangle {
        id: rectangle3
        color: "#ffffff"
        border.color: "#000000"
        anchors.top: rectangle1.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0

        ListView {
            id: resultList
            anchors.fill: parent
            model: resultsModel.dataModel

            delegate: Component {
                Row {
                    spacing: 10
                    Button {
                        id: selectButton
                        text: translator.translate("Choose") + mainView.forceTranslate
                        onClicked: selected({"name": name, "lon": lon, "lat": lat});
                    }
                    Text {
                        text: name
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        width: resultList.width-selectButton.width-20
                    }
                }
            }
        }
    }

}
