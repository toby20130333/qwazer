import QtQuick 1.0
import "../qwazer/js/Images.js" as Images

Page {
    id: searchView
    anchors.fill: parent
    width: 800
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

    tools: VisualItemModel {
        Flow {
            id: toolBarButtons
            anchors.margins: 20
            spacing: 20
            IconButton {
                id: backButton
                text: translator.translate("Back") + translator.forceTranslate
                iconSource: Images.back
                onClicked: searchView.backButtonClicked()
            }

            DualStateButton {
                anchors.verticalCenter: toolBarButtons.verticalCenter
                leftText: translator.translate("Search") + translator.forceTranslate
                rightText: translator.translate("Favorites") + translator.forceTranslate
                selectedIndex: 0
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
