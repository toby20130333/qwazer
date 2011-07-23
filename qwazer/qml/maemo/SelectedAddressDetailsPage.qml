import QtQuick 1.0

Rectangle {
    id: addressDetails
    anchors.fill: parent

    signal backButtonClicked

    property string name
    property string businessName
    property string url
    property string phone
    property variant location

    Flow {
        id: addressToolBar
        anchors.right: addressDetails.right
        anchors.rightMargin: spacing
        anchors.left: addressDetails.left
        anchors.leftMargin: spacing
        anchors.top: addressDetails.top
        spacing: 20

        Button {
            id: backButton
            text: "Back"
            onClicked: addressDetails.backButtonClicked()
        }

        Button {
            id: navigateButton
            text: "Navigate"
        }

        Button {
            id: showLocationButton;
            text: "Show"
        }

        Button {
            id: addTopFavoritesButton;
            text: "Add to Favorites"
        }
    }

    Grid {
        id: detailsGrid
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: addressToolBar.bottom
        anchors.margins: 20
        columns:2
        spacing: 20

        Text {
            text: translator.translate("Address%1", ":") + translator.forceTranslate
        }

        Text {
            text: name
        }

        Text {
            text: translator.translate("Business Name%1", ":") + translator.forceTranslate
            visible: businessName != ""
        }

        Text {
            text: businessName
        }

        Text {
            text: translator.translate("Homepage%1", ":") + translator.forceTranslate
            visible: url != ""
        }

        Text {
            text: url
        }

        Text {
            text: translator.translate("Phone Number%1", ":") + translator.forceTranslate
            visible: phone != ""
        }

        Text {
            text: phone
        }

        Text {
            text: translator.translate("Location%1", ":") + translator.forceTranslate
        }

        Text {
            text: location? location.lon + ", " + location.lat : ""
        }
    }
}
