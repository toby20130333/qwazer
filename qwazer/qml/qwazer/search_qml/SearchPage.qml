import QtQuick 1.0
import "../common_qml"

Page {
    id: searchView
    title: translator.translate("Search") + mainView.forceTranslate

    width:800
    height: 400

    signal addressSelected(variant address)

    toolbarRightItems: VisualItemModel {
        DualStateButton {
            leftText:  translator.translate("Search") + mainView.forceTranslate
            rightText: translator.translate("Favorites") + mainView.forceTranslate
        }
    }

    FindResultsModel {
        id: resultsModel
    }

    Rectangle {
        id: searchList
        anchors.fill: searchView.content

        signal selected(variant selection)

        Rectangle {
            id: rectangle1
            height: 50
            color: "#00000000"
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: searchButton.left
            anchors.rightMargin: 10
            border.color: "#000000"
            clip: true

            TextInput {
                id: searchField
                text: ""
                anchors.fill: parent
                horizontalAlignment: TextInput.AlignRight
                font.pixelSize: 24
            }
        }

        Button {
            id: searchButton
            text: translator.translate("Search") + mainView.forceTranslate
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            onClicked: {
                console.log(searchField.text);
                resultsModel.address = searchField.text;
            }
        }

        Rectangle {
            id: rectangle3
            color: "#00000000"
            border.color: "#000000"
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.top: searchButton.bottom
            anchors.topMargin: 10

            ListView {
                id: resultList
                anchors.fill: parent
                model: resultsModel.dataModel
                clip: true

                delegate: Component {
                    Row {
                        spacing: 10
                        Text {
                            text: name
                            width: resultList.width-selectButton.width-20
                        }

                        Button {
                            id: selectButton
                            text: translator.translate("Choose") + mainView.forceTranslate
                            onClicked: selected({"name": name, "lon": lon, "lat": lat});
                        }

                    }
                }
            }
        }
    }
}
