import QtQuick 1.0
import com.meego 1.0
import "qwazer"

Page {
    id: mainPage

    function initialize() {
        console.log("init");
        map.initialize();
        console.log("end init");
    }

    tools: ToolBarLayout {
        id: commonTools
        visible: true

        ToolIcon {
            id: homeButton;
            y: 0;
            width: 64;
            anchors.left: parent.left;
            anchors.leftMargin: 10;
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
            anchors.right: quitButton.left
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
        ToolIcon { id: showMeButton; anchors.verticalCenterOffset: 0; anchors.rightMargin: 10; platformIconId: "toolbar-directory-move-to"; iconId: "toolbar-directory-move-to";            anchors.right: settingsButton.left
            onClicked: map.showMe(true, true)
        }
        ToolIcon { id: quitButton; anchors.verticalCenterOffset: 0; anchors.rightMargin: 10; platformIconId: "toolbar-close"; iconId: "toolbar-close";            anchors.right: parent===undefined ? undefined : parent.right
            onClicked: Qt.quit()
        }
    }

    QwazerMap {
        id: map

        anchors.fill: mainPage

        onMapLoaded: appWindow.pageStack.push(mainPage)
    }


    SearchAddressPage {id: searchAddressPage}
}
