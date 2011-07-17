import QtQuick 1.0
import com.meego 1.0
import "qwazer/search_qml"

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
                text: "Search"
            }

            Button {
                text: "Favorites"
            }
        }

        ToolIcon { id: backButton; anchors.verticalCenterOffset: 0; anchors.leftMargin: 10; iconId: "toolbar-back"; platformIconId: "toolbar-back"
            anchors.left: parent===undefined ? undefined : parent.left
            onClicked: appWindow.pageStack.pop()
        }
    }


    FindResultsModel {
        id: findAddressModel
        onLoadDone: appWindow.pageStack.push(addressResultsPage)
    }

    AddressResultsPage {
        id: addressResultsPage
    }

    Column {
        Label {
            text: "Enter address to find"
        }

        TextField {
            id: address
            width: searchAddressPage.width
            height: 50
        }


        Button {
            id: searchButton
            text: "Search Address"
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
}
