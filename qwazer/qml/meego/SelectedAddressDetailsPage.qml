import QtQuick 1.0
import com.meego 1.0
import "../qwazer"
import "../qwazer/js/Images.js" as Images

Page {
    id: selectedAddress

    property variant addressDetails

    CourseResultsListModel {
        id: courseResultsModel
        onLoadDone: appWindow.pageStack.replace(courseResultsPage)
        onFromToPointsChanged: appWindow.pageStack.push(loadingResultsPage, null, true)

        BusyPage {
            id: loadingResultsPage

            text: translator.translate("Calculating Course%1", "...") + translator.forceTranslate

            onBackClicked: {
                cancelled = true;
                appWindow.pageStack.pop(undefined, true);
            }
        }
    }

    PathSelectionPage {
        id: courseResultsPage
    }

    tools: ToolBarLayout {

        ToolIcon {
            id: backButton;
            anchors.verticalCenterOffset: 0;
            anchors.leftMargin: 10;
            iconId: "toolbar-back"
            anchors.left: parent===undefined ? undefined : parent.left
            onClicked: appWindow.pageStack.pop()
        }

        ToolIcon {
            id: showButton;
            anchors.verticalCenterOffset: 0;
            anchors.rightMargin: 10;
            iconSource: Images.show
            anchors.right: parent===undefined ? undefined : parent.right
            onClicked: {
                appWindow.pageStack.pop(mainPage);
                mainPage.showLocation(addressDetails.location.lon, addressDetails.location.lat);
            }
        }

        ToolIcon {
            id: navigateButton;
            anchors.verticalCenterOffset: 0;
            anchors.rightMargin: 10;
            iconSource: Images.navigate
            anchors.right: showButton.left
            onClicked:
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

        ToolIcon {
            id: addToFavoritesButton;
            anchors.verticalCenterOffset: 0;
            anchors.rightMargin: 10;
            iconSource: Images.unfavorites
            anchors.right: navigateButton.left
            onClicked: addToFavoritesButton.isSelected = !addToFavoritesButton.isSelected

            property bool isSelected: (typeof(addressDetails) != "undefined")? settings.isFavoriteLocation(addressDetails.name) : false
            onIsSelectedChanged: {
                if (isSelected) {
                    if (settings.isFavoriteLocation(addressDetails.name) === false)
                    {
                        // avoid multiple insertions - only add if not already in
                        settings.addFavoriteLocation(addressDetails);
                    }
                }
                else {
                    settings.removeFavoriteLocation(addressDetails.name);
                }
            }

            states: [
                State {
                    name: "Selected"
                    when: addToFavoritesButton.isSelected
                    PropertyChanges {
                        target: addToFavoritesButton
                        iconSource: Images.favorites
                    }
                },
                State {
                    name: "Unselected"
                    when: !addToFavoritesButton.isSelected
                    PropertyChanges {
                        target: addToFavoritesButton
                        iconSource: Images.unfavorites
                    }
                }
            ]
        }
    }

    Grid {
        anchors.margins: 20
        columns:2
        spacing: 20

        Label {
            text: translator.translate("Address%1", ":") + translator.forceTranslate
        }

        Label {
            text: (typeof(addressDetails) != "undefined")? addressDetails.name : ""
        }

        Label {
            text: translator.translate("Business Name%1", ":") + translator.forceTranslate
            visible: (typeof(addressDetails) != "undefined") && typeof(addressDetails.businessName) != "undefined"
        }

        Label {
            text: (typeof(addressDetails) != "undefined" && typeof(addressDetails.businessName) != "undefined")? addressDetails.businessName : ""
        }

        Label {
            text: translator.translate("Homepage%1", ":") + translator.forceTranslate
            visible: typeof(addressDetails) != "undefined" && typeof(addressDetails.url) != "undefined"
        }

        Label {
            text: (typeof(addressDetails) != "undefined" && typeof(addressDetails.url) != "undefined")? addressDetails.url : ""
        }

        Label {
            text: translator.translate("Phone Number%1", ":") + translator.forceTranslate
            visible: typeof(addressDetails) != "undefined" && typeof(addressDetails.phone) != "undefined"
        }

        Label {
            text: (typeof(addressDetails) != "undefined" && typeof(addressDetails.phone) != "undefined")? addressDetails.phone : ""
        }

        Label {
            text: translator.translate("Location%1", ":") + translator.forceTranslate
        }

        Label {
            text: (typeof(addressDetails) != "undefined" && addressDetails.location)? addressDetails.location.lon + ", " + addressDetails.location.lat : ""
        }
    }
}
