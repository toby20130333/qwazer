import QtQuick 1.0
import com.meego 1.0
import "../qwazer/js/Images.js" as Images
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
        map.navigate(course);
        mainPageStates.state = "Navigation";
    }

    function stopNavigation() {
        map.stopNavigation();
        mainPageStates.state = "Browse";
    }

   tools: ToolBarLayout {
            id: browseTools

            ToolIcon {
                id: settingsButton;
                anchors.verticalCenterOffset: 0;
                anchors.rightMargin: 10;
                iconId: "toolbar-settings"
                anchors.right: parent.right
            }
            ToolIcon {
                id: searchButton;
                anchors.verticalCenterOffset: 0;
                anchors.rightMargin: 10;
                iconId: "toolbar-search"
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
                iconSource: Images.unlock_browse
                property bool isSelected: false

                states: [
                    State {
                        name: "Selected"
                        when:  followMeButton.isSelected

                        PropertyChanges {
                            target: followMeButton
                            iconSource: Images.unlock_browse
                        }
                    },
                    State {
                        name: "UnSelected"
                        when:  !followMeButton.isSelected

                        PropertyChanges {
                            target: followMeButton
                            iconSource: Images.lock_browse
                        }
                    }
                ]
            }
            ToolIcon {
                id: showMeButton;
                visible: !followMeButton.isSelected
                anchors.verticalCenterOffset: 0;
                anchors.rightMargin: 10;
                iconSource: Images.show_me
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

        DirectionGuideControl {
            id: fullScreenInstruction
            border.color: "#00000000"
            anchors.horizontalCenter: map.horizontalCenter
            anchors.verticalCenter: map.verticalCenter
            opacity: 0.3
            color: "#00000000"

            diameter: Math.min(map.width, map.height) - 100

            instructionArg: (typeof(map.currentSegment) != "undefined")? map.currentSegment.instruction.arg : 0
            instructionOpcode: (typeof(map.currentSegment) != "undefined")? map.currentSegment.instruction.opcode : ""
        }

        InstructionsControl {
            id: currentInstruction
            visible: true
            opacity: 0.7
            anchors.bottom: futureDirections.top
            anchors.left: map.left
            length: (typeof(map.currentSegment) != "undefined")? map.currentSegment.length : 0
            instructionArg: (typeof(map.currentSegment) != "undefined")? map.currentSegment.instruction.arg : 0
            instructionOpcode: (typeof(map.currentSegment) != "undefined")? map.currentSegment.instruction.opcode : ""
            streetName: (typeof(map.currentSegment) != "undefined" && typeof(map.currentSegment.streetName) != "undefined")? map.currentSegment.streetName : ""
        }

        DirectionGuideList {
            id: futureDirections
            anchors.left: map.left
            anchors.bottom: map.bottom
            model: map.navigationSegments
        }
    }

    Notification {
        text: translator.translate("Bad GPS Reception") + translator.forceTranslate

        active: !isGPSDataValid
    }

    SearchAddressPage {
        id: searchAddressPage
        anchors.fill: parent
    }

    MainPageLogic {
        id: mainPageStates
        state: "Browse"
        onShowApplicationSettings: appWindow.pageStack.push(settingsPage)
        onShowNavigationSettings: appWindow.pageStack.push(settingsPage)
    }
}
