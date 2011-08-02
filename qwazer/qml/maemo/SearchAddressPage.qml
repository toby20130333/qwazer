import QtQuick 1.0
import "../qwazer/search_qml"
import "../qwazer/js/Images.js" as Images

Page {
    id:searchAddressPage
    width: 800
    height: 400

    signal backButtonClicked

    tools: VisualItemModel {
        Flow {
            id: searchAddressToolBar
            IconButton {
                id: backButton;
                iconSource: Images.back
                text: translator.translate("Back") + translator.forceTranslate
                onClicked: backButtonClicked()
            }

            DualStateButton {
                anchors.verticalCenter: searchAddressToolBar.verticalCenter
                leftText: translator.translate("Search") + translator.forceTranslate
                rightText: translator.translate("Favorites") + translator.forceTranslate
                selectedIndex: 0
            }
        }
    }

    content: VisualItemModel {
        Column {
            id: searchPageContent
            spacing: 20
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            anchors.topMargin: 20
            anchors.fill: searchAddressPage

            Text {
                anchors.horizontalCenter: searchPageContent.horizontalCenter
                text: translator.translate("Enter address to find") + translator.forceTranslate
            }

            Rectangle {
                height: 50
                anchors.right: parent.right
                anchors.left: parent.left
                border.color: "black"

                TextEdit {
                    id: address
                    anchors.fill: parent
                }
            }


            Button {
                id: searchButton
                anchors.horizontalCenter: searchPageContent.horizontalCenter
                text: translator.translate("Search Address") + translator.forceTranslate
                onClicked: {
                    if (findAddressModel.address != address.text)
                    {
                        findAddressModel.address = address.text;
                    }
                    else
                    {
                        activePage = addressResultsPage;
                    }
                }
            }
        }
    }
}
