import QtQuick 1.0

Rectangle {
    id: searchView
    anchors.fill: parent
    width: 780
    height: 400

    signal backButtonClicked

    SearchListControl {
        id: searchControl
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottom: backButton.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottomMargin: 10
        anchors.topMargin: 10
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

    Button {
        id: backButton
        text: translator.translate("Back") + translator.forceTranslate
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.right: searchControl.left
        anchors.left: searchControl.right
        onClicked: searchView.backButtonClicked()
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
