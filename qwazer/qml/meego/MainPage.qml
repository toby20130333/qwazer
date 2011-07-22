import QtQuick 1.0
import com.meego 1.0
import "../qwazer"

Page {
    id: mainPage

    property alias isGPSDataValid :  mainPageStates.isGPSDataValid

    function initialize() {
        map.initialize();
    }

    function showLocation(lon, lat) {
        map.showLocation(lon, lat);
    }

    function navigate(course) {
        map.navigationInfo = course;
        mainPageStates.state = "Navigation";
    }

    function stopNavigation() {
        map.stopNavigation();
        mainPageStates.state = "Browse";
    }

   tools: ToolBarLayout {
            id: browseTools

            ToolIcon {
                id: homeButton;
                y: 0;
                width: 64;
                anchors.right: parent.right;
                anchors.rightMargin: 10;
                anchors.verticalCenterOffset: 0;
                iconId: "toolbar-home";
                platformIconId: "toolbar-home"
                onClicked: console.log("home clicked")
            }
            ToolIcon {
                id: settingsButton;
                anchors.verticalCenterOffset: 0;
                anchors.rightMargin: 10;
                iconId: "toolbar-settings";
                platformIconId: "toolbar-settings"
                anchors.right: homeButton.left
            }
            ToolIcon {
                id: searchButton;
                anchors.verticalCenterOffset: 0;
                anchors.rightMargin: 10;
                platformIconId: "toolbar-search";
                iconId: "toolbar-search";
                anchors.right: followMeButton.left
                onClicked: mainPage.pageStack.push(searchAddressPage)
            }
            ToolIcon {
                id: stopNavigationButton;
                anchors.verticalCenterOffset: 0;
                anchors.rightMargin: 10;
                platformIconId: "toolbar-stop";
                iconId: "toolbar-stop";
                anchors.right: followMeButton.left
                onClicked: mainPage.stopNavigation()
            }
            ToolIcon {
                id: followMeButton;
                anchors.verticalCenterOffset: 0;
                anchors.rightMargin: 10;
                anchors.right: showMeButton.left
                onClicked: followMeButton.isSelected = !followMeButton.isSelected
                iconId: "toolbar-unlocked"
                property bool isSelected: false

                states: [
                    State {
                        name: "Selected"
                        when:  followMeButton.isSelected

                        PropertyChanges {
                            target: followMeButton
                            iconId: "toolbar-unlocked"
                            platformIconId: "toolbar-unlocked"
                        }
                    },
                    State {
                        name: "UnSelected"
                        when:  !followMeButton.isSelected

                        PropertyChanges {
                            target: followMeButton
                            iconId: "toolbar-locked"
                            platformIconId: "toolbar-locked"
                        }
                    }
                ]
            }
            ToolIcon {
                id: showMeButton;
                visible: !followMeButton.isSelected
                anchors.verticalCenterOffset: 0;
                anchors.rightMargin: 10;
                platformIconId: "toolbar-directory-move-to";
                iconId: "toolbar-directory-move-to";
                anchors.right: settingsButton.left
                onClicked: map.showMe(true, true)
            }
            ToolIcon { id: quitButton; anchors.verticalCenterOffset: 0; anchors.leftMargin: 10; platformIconId: "toolbar-close"; iconId: "toolbar-close";            anchors.left: parent===undefined ? undefined : parent.left
                onClicked: Qt.quit()
            }
        }

    QwazerMap {
        id: map

        anchors.fill: mainPage

        isFollowMe: followMeButton.isSelected
        onMapLoaded: appWindow.pageStack.replace(mainPage)

        ButtonColumn {
            anchors.right: map.right
            anchors.rightMargin: 10
            anchors.verticalCenter: map.verticalCenter
            exclusive: false
            width: 50

            Button {
                text: "+"
                onClicked: map.zoomIn()
            }

            Button {
                text: "-"
                onClicked: map.zoomOut()
            }
        }
    }

    InstructionsControl {
        id: currentInstruction
        visible: false
        anchors.bottom: mainPage.bottom
        anchors.bottomMargin: 10
        anchors.left: mainPage.left
        opacity: 0.7
    }

    Notification {
        text: translator.translate("Bad GPS Reception") + translator.forceTranslate

        active: !isGPSDataValid
    }

    SearchAddressPage {id: searchAddressPage}

    NavSettingsPage {id: navSettingsPage }

    MainPageLogic {
        id: mainPageStates
        state: "Browse"
    }
}
