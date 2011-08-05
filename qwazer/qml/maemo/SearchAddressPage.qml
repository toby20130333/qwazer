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
                id: pageState
                anchors.verticalCenter: searchAddressToolBar.verticalCenter
                leftText: translator.translate("Search") + translator.forceTranslate
                rightText: translator.translate("Favorites") + translator.forceTranslate
                selectedIndex: 0
            }
        }
    }

    content: VisualItemModel {

        Rectangle {
            anchors.fill: parent

            Rectangle {
                id: favoritesPageContent
                anchors.fill: parent

                Text {
                    id: favoriteDescText
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: translator.translate("Select a favorite location") + translator.forceTranslate
                }

                Rectangle {
                    border.color: "black"
                    radius: 10
                    anchors.margins: 10
                    anchors.top: favoriteDescText.bottom
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom

                    ListView {
                        anchors.fill: parent
                        clip: true
                        model: settings.favoriteLocations
                        delegate: Component {
                            ListItem {
                                text:name
                                onClicked: {
                                    if (typeof(addressDetailsPage.addressDetails) == "undefined" ||
                                        addressDetailsPage.addressDetails.name != name)
                                    {
                                        addressDetailsPage.addressDetails =  {name: name,
                                                location: location,
                                                phone: phone? phone:"",
                                                url: url? url:"",
                                                businessName: businessName? businessName:""};
                                    }
                                    else
                                    {
                                        addressDetailsPage.addressDetailsChanged();
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Column {
                id: searchPageContent
                spacing: 20
                anchors.fill: parent

                Text {
                    anchors.horizontalCenter: searchPageContent.horizontalCenter
                    text: translator.translate("Enter address to find") + translator.forceTranslate
                }

                Rectangle {
                    height: 50
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 20
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

            states: [
                State {
                    name: "Search"
                    when: pageState.selectedIndex == 0
                    PropertyChanges {
                        target: searchPageContent
                        visible: true
                    }
                    PropertyChanges {
                        target: favoritesPageContent
                        visible: false
                    }
                },
                State {
                    name: "Favorites"
                    when: pageState.selectedIndex == 1
                    PropertyChanges {
                        target: searchPageContent
                        visible: false
                    }
                    PropertyChanges {
                        target: favoritesPageContent
                        visible: true
                    }
                }
            ]
        }
    }
}
