import QtQuick 1.0
import "../common_qml"

Page {
    id: searchView
    title: translator.translate("Search") + mainView.forceTranslate

    width:800
    height: 400

    property alias ws_url : resultsModel.ws_url

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

        Column {
            spacing: 10
            anchors.leftMargin: 10

            Row {
                spacing: 10
                Rectangle {
                    id: rectangle1
                    height: 50
                    color: "#ffffff"
                    border.color: "#000000"
                    width: searchView.width - searchButton.width - 20
                    clip: true

                    TextInput {
                        id: searchField
                        text: ""
                        horizontalAlignment: TextInput.AlignRight
                        font.pixelSize: 24
                    }
                }

                Button {
                    id: searchButton
                    text: translator.translate("Search") + mainView.forceTranslate
                    onClicked: {
                        resultsModel.address = searchField.text;
                    }
                }
            }

            Rectangle {
                id: rectangle3
                color: "#ffffff"
                border.color: "#000000"

                ListView {
                    id: resultList
                    anchors.fill: rectangle3
                    model: resultsModel.dataModel

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
}
