import QtQuick 1.0
import com.meego 1.0
import QtMobility.systeminfo 1.1
import "../qwazer/js/Images.js" as Images
import "../qwazer"

Page {
    id: mainPage

    orientationLock: PageOrientation.LockLandscape

    property alias isGPSDataValid :  mainPageStates.isGPSDataValid
    property bool firstLoad: true

    property bool navigationScreenStaysLit: settings.navigationScreenStaysLit
    onNavigationScreenStaysLitChanged: updateScreenSaverStatus()

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

    function updateScreenSaverStatus() {
        screenSaver.setScreenSaverInhibit((mainPageStates.state == "Navigation")? settings.navigationScreenStaysLit : false);
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
        }

    QwazerMap {
        id: map
        state: mainPageStates.state
        anchors.fill: mainPage

        isFollowMe: followMeButton.isSelected
        onMapLoaded: {
            if (firstLoad)
            {
                appWindow.pageStack.replace(mainPage);
                firstLoad = false;
            }
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

    ScreenSaver {
        id: screenSaver
    }

    MainPageLogic {
        id: mainPageStates
        state: "Browse"
        onStateChanged: mainPage.updateScreenSaverStatus()
        onShowApplicationSettings: appWindow.pageStack.push(settingsPage)
        onShowNavigationSettings: appWindow.pageStack.push(settingsPage)
    }
}
