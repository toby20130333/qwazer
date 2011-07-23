import QtQuick 1.0
import com.meego 1.0
import "../qwazer/search_qml"

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
                text: translator.translate("Search") + translator.forceTranslate
            }

            Button {
                text: translator.translate("Favorites") + translator.forceTranslate
            }
        }

        ToolIcon { id: backButton; anchors.verticalCenterOffset: 0; anchors.leftMargin: 10; iconId: "toolbar-back"; platformIconId: "toolbar-back"
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

    Column {
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
}
