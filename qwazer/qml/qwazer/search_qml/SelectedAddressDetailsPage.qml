import QtQuick 1.0
import com.meego 1.0
import ".."

Page {
    id: selectedAddress

    property string name
    property string businessName
    property string url
    property string phone
    property variant location

    CourseResultsListModel {
        id: courseResultsModel
        onLoadDone: appWindow.pageStack.push(courseResultsPage)
    }

    PathSelectionPage {
        id: courseResultsPage
    }

    tools: ToolBarLayout {

        ToolIcon {
            id: backButton;
            anchors.verticalCenterOffset: 0;
            anchors.leftMargin: 10;
            iconId: "toolbar-back";
            platformIconId: "toolbar-back"
            anchors.left: parent===undefined ? undefined : parent.left
            onClicked: appWindow.pageStack.pop()
        }

        ToolIcon {
            id: showButton;
            anchors.verticalCenterOffset: 0;
            anchors.rightMargin: 10;
            iconId: "toolbar-refresh";
            platformIconId: "toolbar-refresh"
            anchors.right: parent===undefined ? undefined : parent.right
            onClicked: {
                appWindow.pageStack.pop(mainPage);
                mainPage.showLocation(location.lon, location.lat);
            }
        }

        ToolIcon {
            id: navigateButton;
            anchors.verticalCenterOffset: 0;
            anchors.rightMargin: 10;
            iconId: "toolbar-share";
            platformIconId: "toolbar-share"
            anchors.right: showButton.left
            onClicked:
                if (!courseResultsModel.fromToPoints ||
                    courseResultsModel.fromToPoints.to.lon != location.lon ||
                    courseResultsModel.fromToPoints.to.lat != location.lat)
                {
                    courseResultsModel.fromToPoints = {to: location, from:{lon: gpsData.position.coordinate.longitude ,lat: gpsData.position.coordinate.latitude}};
                }
                else
                {
                    courseResultsModel.onLoadDone();
                }
        }

        ToolIcon {
            id: addToFavoritesButton;
            anchors.verticalCenterOffset: 0;
            anchors.rightMargin: 10;
            iconId: "toolbar-add";
            platformIconId: "toolbar-add"
            anchors.right: navigateButton.left
            onClicked: appWindow.pageStack.pop()
        }
    }

    Grid {
        anchors.margins: 20
        columns:2
        spacing: 20

        Label {
            text: "Address:"
        }

        Label {
            text: name
        }

        Label {
            text: "Business Name:"
            visible: businessName != ""
        }

        Label {
            text: businessName
        }

        Label {
            text: "Homepage:"
            visible: url != ""
        }

        Label {
            text: url
        }

        Label {
            text: "Phone Number:"
            visible: phone != ""
        }

        Label {
            text: phone
        }

        Label {
            text: "Location:"
        }

        Label {
            text: location? location.lon + ", " + location.lat : ""
        }
    }
}
