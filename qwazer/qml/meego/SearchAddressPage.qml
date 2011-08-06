import QtQuick 1.0
import com.meego 1.0
import "../qwazer"
import "../qwazer/search_qml"
import "../qwazer/js/Images.js" as Images

Page {
    id:searchAddressPage
    width: 800
    height: 400

    tools: ToolBarLayout {
        id: backButtonWithModeToolbar
        ButtonRow {
            anchors.right: parent.right
            anchors.rightMargin: 10
            Button {
                id: searchStateButton
                iconSource: Images.find
                text: translator.translate("Search") + translator.forceTranslate
            }

            Button {
                id: favoritesStateButton
                iconSource: Images.favorites
                text: translator.translate("Favorites") + translator.forceTranslate
            }
        }

        ToolIcon {
            id: backButton;
            anchors.verticalCenterOffset: 0;
            anchors.leftMargin: 10;
            iconSource: Images.back
            anchors.left: parent===undefined ? undefined : parent.left
            onClicked: appWindow.pageStack.pop()
        }
    }


    FindResultsModel {
        id: findAddressModel
        onLoadDone: appWindow.pageStack.replace(addressResultsPage)
        onAddressChanged: appWindow.pageStack.push(loadingResultsPage, null, true)

        BusyPage {
            id: loadingResultsPage

            text: translator.translate("Searching for address%1", "...") + translator.forceTranslate

            onBackClicked: {
                cancelled = true;
                appWindow.pageStack.pop(undefined, true);
            }
        }
    }

    AddressResultsPage {
        id: addressResultsPage
    }

    SelectedAddressDetailsPage {
        id: addressDetailsPage
    }

    Rectangle {
        anchors.fill: parent
        Column {
            id: searchPageContent
            Label {
                text: translator.translate("Enter address to find") + translator.forceTranslate
            }

            TextField {
                id: address
                width: searchAddressPage.width
                height: 50
            }


            Button {
                id: searchButton
                text: translator.translate("Search Address") + translator.forceTranslate
                onClicked: {
                    if (findAddressModel.address != address.text)
                    {
                        findAddressModel.address = address.text;
                    }
                    else
                    {
                        appWindow.pageStack.push(addressResultsPage);
                    }
                }
            }
        }

        Rectangle {
            id: favoritesPageContent
            anchors.fill: parent

            Label {
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
                    id: locationsList
                    anchors.fill: parent
                    clip: true
                    model: settings.favoriteLocations
                    delegate: Component {
                        ListItem {
                            text:name
                            width: locationsList.width
                            onClicked: {
                                var o = settings.favoriteLocations.get(index);
                                appWindow.pageStack.push(addressDetailsPage, {addressDetails: o});
                            }
                        }
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "Search"
            when: searchStateButton.checked
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
            when: favoritesStateButton.checked
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
