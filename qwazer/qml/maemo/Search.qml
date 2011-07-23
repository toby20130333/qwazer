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
            addressDetails.name = selection.name;
            addressDetails.location = selection.location;
            addressDetails.phone = selection.phone;
            addressDetails.url = selection.url;
            addressDetails.businessName = selection.businessName;
            searchView.state = "SearchResults";
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
        id: addressDetails

        onBackButtonClicked: searchView.state = "Search"
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
                target: addressDetails
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
                target: addressDetails
                visible: true
            }
        }
    ]
}
