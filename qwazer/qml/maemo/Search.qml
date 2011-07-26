import QtQuick 1.0
import "../qwazer/js/Images.js" as Images

Rectangle {
    id: searchView
    anchors.fill: parent
    width: 780
    height: 400

    signal backButtonClicked

    SearchListControl {
        id: searchControl
        anchors.margins: 10
        anchors.fill: searchView
        onSelected: {
            if (typeof(addressDetailsPage.addressDetails) == "undefined" ||
                addressDetailsPage.addressDetails.name != selection.name)
            {
                addressDetailsPage.addressDetails = selection;
            }
            else
            {
                addressDetailsPage.addressDetailsChanged();
            }
        }
    }

    ToolBar {
        height: toolBarButtons.height
        toolBarItems:
        Flow {
            id: toolBarButtons
            spacing: 20
            IconButton {
                id: backButton
                text: translator.translate("Back") + translator.forceTranslate
                iconSource: Images.back
                onClicked: searchView.backButtonClicked()
            }
        }
    }

    SelectedAddressDetailsPage {
        id: addressDetailsPage

        onBackButtonClicked: searchView.state = "Search"
        onAddressDetailsChanged: searchView.state = "SearchResults"
    }

    states: [
        State {
            name: "Search"
            PropertyChanges {
                target: searchControl
                visible: true
            }
            PropertyChanges {
                target: backButton
                visible: true
            }
            PropertyChanges {
                target: addressDetailsPage
                visible: false
            }
        },
        State {
            name: "SearchResults"
            PropertyChanges {
                target: searchControl
                visible: false
            }
            PropertyChanges {
                target: backButton
                visible: false
            }
            PropertyChanges {
                target: addressDetailsPage
                visible: true
                state: "AddressDetails"
            }
        }
    ]
}
