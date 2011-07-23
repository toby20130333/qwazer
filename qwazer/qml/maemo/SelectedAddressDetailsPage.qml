import QtQuick 1.0
import "../qwazer"

Rectangle {
    id: addressDetailsPage
    anchors.fill: parent

    signal backButtonClicked

    property variant addressDetails: {
                                         name: "",
                                         location: {lon: "", lat:""},
                                         phone: "",
                                         url: "",
                                         businessName: ""
                                     }

    CourseResultsListModel {
        id: courseResultsModel
        onLoadDone: addressDetailsPage.state = "PathSelection"
    }

    PathSelection {
        id: courseResultsPage
        onBackButtonClicked: addressDetailsPage.state = "AddressDetails"
    }

    Flow {
        id: addressToolBar
        anchors.right: addressDetailsPage.right
        anchors.rightMargin: spacing
        anchors.left: addressDetailsPage.left
        anchors.leftMargin: spacing
        anchors.top: addressDetailsPage.top
        spacing: 20

        Button {
            id: backButton
            text: "Back"
            onClicked: addressDetailsPage.backButtonClicked()
        }

        Button {
            id: navigateButton
            text: "Navigate"
            onClicked: {
                if (!courseResultsModel.fromToPoints ||
                    courseResultsModel.fromToPoints.to.lon != addressDetails.location.lon ||
                    courseResultsModel.fromToPoints.to.lat != addressDetails.location.lat)
                {
                    courseResultsModel.fromToPoints = {to: addressDetails.location, from:{lon: gpsData.position.coordinate.longitude ,lat: gpsData.position.coordinate.latitude}};
                }
                else
                {
                    courseResultsModel.loadDone();
                }
            }
        }

        Button {
            id: showLocationButton;
            text: "Show"
            onClicked: {
                mainView.state = "MapState";
                qwazerMapView.showLocation(addressDetails.location.lon, addressDetails.location.lat);
            }
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
            text: addressDetails.name
        }

        Text {
            text: translator.translate("Business Name%1", ":") + translator.forceTranslate
            visible: addressDetails.businessName !== ""
        }

        Text {
            text: addressDetails.businessName
        }

        Text {
            text: translator.translate("Homepage%1", ":") + translator.forceTranslate
            visible: addressDetails.url !== ""
        }

        Text {
            text: addressDetails.url
        }

        Text {
            text: translator.translate("Phone Number%1", ":") + translator.forceTranslate
            visible: addressDetails.phone !== ""
        }

        Text {
            text: addressDetails.phone
        }

        Text {
            text: translator.translate("Location%1", ":") + translator.forceTranslate
        }

        Text {
            text: addressDetails.location? addressDetails.location.lon + ", " + addressDetails.location.lat : ""
        }
    }

    states: [
        State {
            name: "AddressDetails"
            PropertyChanges {
                target: addressToolBar
                visible: true
            }
            PropertyChanges {
                target: detailsGrid
                visible: true
            }
            PropertyChanges {
                target: courseResultsPage
                visible: false
            }
        },
        State {
            name: "PathSelection"
            PropertyChanges {
                target: addressToolBar
                visible: false
            }
            PropertyChanges {
                target: detailsGrid
                visible: false
            }
            PropertyChanges {
                target: courseResultsPage
                visible: true
            }
        }
    ]
}
