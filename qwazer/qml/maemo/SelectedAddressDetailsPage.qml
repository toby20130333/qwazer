import QtQuick 1.0
import "../qwazer"
import "../qwazer/js/Images.js" as Images

Page {
    id: addressDetailsPage
    anchors.fill: parent

    signal backButtonClicked

    property variant addressDetails

    tools: VisualItemModel {
        Flow {
            id: addressToolBar
            anchors.margins: 20
            spacing: 20

            IconButton {
                text: translator.translate("Back") + translator.forceTranslate
                iconSource: Images.back
                onClicked: addressDetailsPage.backButtonClicked()
            }

            IconButton {
                id: navigateButton
                text: translator.translate("Navigate") + translator.forceTranslate
                iconSource: Images.navigate
                onClicked: {
                    if (!courseResultsModel.fromToPoints ||
                        courseResultsModel.fromToPoints.to.lon != addressDetails.location.lon ||
                        courseResultsModel.fromToPoints.to.lat != addressDetails.location.lat)
                    {
                        activePage = courseCalcBusyPage;
                        courseResultsModel.fromToPoints = {to: addressDetails.location, from:{lon: gpsData.position.coordinate.longitude ,lat: gpsData.position.coordinate.latitude}};
                    }
                    else
                    {
                        courseResultsModel.loadDone();
                    }
                }
            }

            IconButton {
                id: showLocationButton;
                text: translator.translate("Show") + translator.forceTranslate
                iconSource: Images.show
                onClicked: {
                    activePage = qwazerMapView;
                    qwazerMapView.showLocation(addressDetails.location.lon, addressDetails.location.lat);
                }
            }

            IconButton {
                id: addFavoritesButton;
                onClicked: addFavoritesButton.isSelected = !addFavoritesButton.isSelected
                iconSource: Images.unfavorites
                text: translator.translate("Unfavorite") + translator.forceTranslate
                property bool isSelected: (typeof(addressDetails) != "undefined")? settings.isFavoriteLocation(addressDetails.name) : false
                onIsSelectedChanged: {
                    if (isSelected) {
                        settings.addFavoriteLocation(addressDetails);
                    }
                    else {
                        settings.removeFavoriteLocation(addressDetails.name);
                    }
                }

                states: [
                    State {
                        name: "Selected"
                        when:  addFavoritesButton.isSelected

                        PropertyChanges {
                            target: addFavoritesButton
                            text: translator.translate("Favorite") + translator.forceTranslate
                            iconSource: Images.favorites
                        }
                    },
                    State {
                        name: "UnSelected"
                        when:  !addFavoritesButton.isSelected

                        PropertyChanges {
                            target: addFavoritesButton
                            text: translator.translate("Unfavorite") + translator.forceTranslate
                            iconSource: Images.unfavorites
                        }
                    }
                ]
            }
        }
    }

    content: VisualItemModel {
        Grid {
            id: detailsGrid
            anchors.margins: 20
            columns:2
            spacing: 20

            Text {
                text: translator.translate("Address%1", ":") + translator.forceTranslate
            }

            Text {
                text: (typeof(addressDetails) != "undefined")? addressDetails.name : ""
            }

            Text {
                text: translator.translate("Business Name%1", ":") + translator.forceTranslate
                visible: (typeof(addressDetails) != "undefined") && addressDetails.businessName !== ""
            }

            Text {
                text: (typeof(addressDetails) != "undefined")? addressDetails.businessName : ""
            }

            Text {
                text: translator.translate("Homepage%1", ":") + translator.forceTranslate
                visible: typeof(addressDetails) != "undefined" && addressDetails.url !== ""
            }

            Text {
                text: (typeof(addressDetails) != "undefined")? addressDetails.url : ""
            }

            Text {
                text: translator.translate("Phone Number%1", ":") + translator.forceTranslate
                visible: typeof(addressDetails) != "undefined" && addressDetails.phone !== ""
            }

            Text {
                text: (typeof(addressDetails) != "undefined")? addressDetails.phone : ""
            }

            Text {
                text: translator.translate("Location%1", ":") + translator.forceTranslate
            }

            Text {
                text: (typeof(addressDetails) != "undefined" && addressDetails.location)? addressDetails.location.lon + ", " + addressDetails.location.lat : ""
            }
        }
    }
}
