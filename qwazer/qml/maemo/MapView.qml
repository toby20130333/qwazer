import QtQuick 1.0
import "../qwazer"
import "../qwazer/js/Images.js" as Images

Page {
    id: mainPage

    width: parent.width
    height: parent.height

    signal mapLoaded
    signal settingsButtonClicked
    signal searchButtonClicked

    function initialize()
    {
        map.initialize();
    }

    function showLocation(lon, lat) {
        map.showLocation(lon, lat);
    }

    function navigate(course) {
        map.navigationInfo = course;
        mainPageLogic.state = "Navigation";
        activePage = qwazerMapView;
    }

    function stopNavigation() {
        map.stopNavigation();
        mainPageLogic.state = "Browse";
    }

    content: VisualItemModel {
        Rectangle {
            width: container.width
            height: container.height

            QwazerMap {
                id: map
                anchors.fill: parent
                isFollowMe: followMeButton.isSelected
                onMapLoaded: mainPage.mapLoaded()

                Column {
                    id: zoomButtons
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 50
                    width: 50

                    Button {
                        text: "+"
                        width: height
                        radius: height
                        onClicked: map.zoomIn()
                    }

                    Button {
                        text: "-"
                        width: height
                        radius: height
                        onClicked: map.zoomOut()
                    }
                }
            }
        }
    }

    tools: VisualItemModel {
        Flow {
            id: toolBarButtons
            anchors.margins: 20
            spacing: 20

            IconButton {
                id: searchButton
                iconSource: Images.find
                text: translator.translate("Search") + translator.forceTranslate
                onClicked: searchButtonClicked()
            }

            IconButton {
                id: settingsButton
                iconSource: Images.settings
                text: translator.translate("Settings") + translator.forceTranslate
                onClicked: settingsButtonClicked()
            }

            Button {
                id: stopNavigationButton;
                text: translator.translate("Stop Nav") + translator.forceTranslate
                onClicked: mainPage.stopNavigation()
            }
            IconButton {
                id: followMeButton;
                onClicked: followMeButton.isSelected = !followMeButton.isSelected
                iconSource: Images.unlock_browse
                text: translator.translate("Unlocked") + translator.forceTranslate
                property bool isSelected: false

                states: [
                    State {
                        name: "Selected"
                        when:  followMeButton.isSelected

                        PropertyChanges {
                            target: followMeButton
                            text: translator.translate("Locked") + translator.forceTranslate
                            iconSource: Images.lock_browse
                        }
                    },
                    State {
                        name: "UnSelected"
                        when:  !followMeButton.isSelected

                        PropertyChanges {
                            target: followMeButton
                            text: translator.translate("Unlocked") + translator.forceTranslate
                            iconSource: Images.unlock_browse
                        }
                    }
                ]
            }
            IconButton {
                id: showMeButton;
                text: translator.translate("Show Me") + translator.forceTranslate
                iconSource: Images.show_me
                visible: !followMeButton.isSelected
                onClicked: map.showMe(true, true)
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

    MainPageLogic {
        id: mainPageLogic
        state:  "Browse"
        onShowApplicationSettings: settingsButtonClicked()
        onShowNavigationSettings: settingsButtonClicked()
    }
}
