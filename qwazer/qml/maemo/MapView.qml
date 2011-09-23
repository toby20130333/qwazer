import QtQuick 1.0
import QtMobility.systeminfo 1.1
import "../qwazer"
import "../qwazer/js/Images.js" as Images

Page {
    id: mainPage

    width: parent.width
    height: parent.height

    signal mapLoaded
    signal settingsButtonClicked
    signal searchButtonClicked

    property alias isGPSDataValid :  mainPageLogic.isGPSDataValid
    property bool firstLoad: true

    property bool navigationScreenStaysLit: settings.navigationScreenStaysLit
    onNavigationScreenStaysLitChanged: updateScreenSaverStatus()

    function initialize()
    {
        map.initialize();
    }

    function showLocation(lon, lat) {
        map.showLocation(lon, lat);
    }

    function navigate(course) {
        map.navigate(course);
        mainPageLogic.state = "Navigation";
    }

    function stopNavigation() {
        map.stopNavigation();
        mainPageLogic.state = "Browse";
    }

    function updateScreenSaverStatus() {
        screenSaver.setScreenSaverInhibit((mainPageLogic.state == "Navigation")? settings.navigationScreenStaysLit : false);
    }

    content: VisualItemModel {
        Rectangle {
            width: container.width
            height: container.height

            QwazerMap {
                id: map
                anchors.fill: parent
                state: mainPageLogic.state
                isFollowMe: followMeButton.isSelected
                onMapLoaded: {
                    if (mainPage.firstLoad)
                    {
                        mainPage.firstLoad = false;
                        mainPage.mapLoaded();
                    }
                }

                Notification {
                    text: translator.translate("Bad GPS Reception") + translator.forceTranslate

                    active: !isGPSDataValid
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

    ScreenSaver {
        id: screenSaver
    }

    MainPageLogic {
        id: mainPageLogic
        state:  "Browse"
        onShowApplicationSettings: settingsButtonClicked()
        onShowNavigationSettings: settingsButtonClicked()
    }
}
