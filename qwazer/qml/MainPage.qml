import QtQuick 1.0
import com.meego 1.0
import "qwazer"

Page {
    id: mainPage
    state: "Browse"

    function initialize() {
        map.initialize();
    }

    function showLocation(lon, lat) {
        map.showLocation(lon, lat);
    }

    function navigate(course) {
        map.navigationInfo = course;
        state = "Navigation";
    }

    function stopNavigation() {
        map.stopNavigation();
        state = "Browse";
    }

    Item {
        ToolBarLayout {
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
                onClicked: appWindow.pageStack.push(settingsPage)
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
    }

    Item {
        ToolBarLayout {
            id: navigationTools

            ToolIcon {
                id: navHomeButton;
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
                id: navSettingsButton;
                anchors.verticalCenterOffset: 0;
                anchors.rightMargin: 10;
                iconId: "toolbar-settings";
                platformIconId: "toolbar-settings"
                anchors.right: navHomeButton.left
                onClicked: appWindow.pageStack.push(navSettingsPage)
            }
            ToolIcon {
                id: navFollowMeButton;
                anchors.verticalCenterOffset: 0;
                anchors.rightMargin: 10;
                anchors.right: navShowMeButton.left
                onClicked: followMeButton.isSelected = !followMeButton.isSelected
                iconId: "toolbar-unlocked"
                property bool isSelected: true

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
                id: navShowMeButton;
                visible: !navFollowMeButton.isSelected
                anchors.verticalCenterOffset: 0;
                anchors.rightMargin: 10;
                platformIconId: "toolbar-directory-move-to";
                iconId: "toolbar-directory-move-to";
                anchors.right: navSettingsButton.left
                onClicked: map.showMe(true, true)
            }
            ToolIcon {
                id: stopNavigation;
                anchors.verticalCenterOffset: 0;
                anchors.rightMargin: 10;
                platformIconId: "toolbar-stop";
                iconId: "toolbar-stop";
                anchors.right: navShowMeButton.left
                onClicked: stopNavigation()
            }
            ToolIcon {
                id: navQuitButton;
                anchors.verticalCenterOffset: 0;
                anchors.leftMargin: 10;
                platformIconId: "toolbar-close";
                iconId: "toolbar-close";
                anchors.left: parent===undefined ? undefined : parent.left
                onClicked: Qt.quit()
            }
        }
    }

    QwazerMap {
        id: map

        anchors.fill: mainPage

        onMapLoaded: appWindow.pageStack.replace(mainPage)
    }

    InstructionsControl {
        id: currentInstruction
        visible: false
        anchors.bottom: mainPage.bottom
        anchors.bottomMargin: 10
        anchors.left: mainPage.left
    }

    SearchAddressPage {id: searchAddressPage}

    states: [
        State {
            name: "Browse"
            PropertyChanges {
                target: mainPage
                tools: browseTools
            }
            PropertyChanges {
                target: map
                isFollowMe: followMeButton.isSelected
            }
            PropertyChanges {
                target: gpsData
                onPositionChanged: map.showMe()
            }
            PropertyChanges {
                target: currentInstruction
                visible: false
            }
        },
        State {
            name: "Navigation"
            PropertyChanges {
                target: mainPage
                tools: navigationTools
            }
            PropertyChanges {
                target: currentInstruction
                visible: true
            }
            PropertyChanges {
                target: map
                isFollowMe: navFollowMeButton.isSelected
            }
            PropertyChanges {
                target: gpsData
                onPositionChanged: map.syncLocation()
            }
        }
    ]
}
