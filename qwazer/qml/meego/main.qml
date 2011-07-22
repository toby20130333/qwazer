import QtQuick 1.0
import com.meego 1.0
import "../qwazer"

PageStackWindow {
    id: appWindow

    initialPage: settingsLoadPage

    Component.onCompleted: {
        settings.initialize();
    }

    property alias gpsData: gps.positionSource

    GPSProvider {
        id: gps
    }

    QwazerSettings {
        id: settings

        onSettingsLoaded: {
            if (typeof(settings.isFirstRun) == "undefined" || settings.isFirstRun)
            {
                appWindow.pageStack.replace(settingsPage, null, true);
            }
            else
            {
                mainPage.initialize();
            }
        }
    }

    Translator { id: translator }

    ToolBar {
        id: commonToolBar
        anchors.bottom: parent.bottom
    }

    MouseArea {
         anchors.fill: parent
         enabled: pageStack.busy
    }

    BusyPage {
        id: settingsLoadPage
        backIcon: "toolbar-close"
        onBackClicked: Qt.quit()
    }

    MainPage{id: mainPage}

    SettingsPage {
        id: settingsPage
    }

    Item {
        ToolBarLayout {
            id: commonBackButtonToolbar
            ToolIcon { id: backButton; anchors.verticalCenterOffset: 0; anchors.leftMargin: 10; iconId: "toolbar-back"; platformIconId: "toolbar-back"
                anchors.left: parent===undefined ? undefined : parent.left
                onClicked: appWindow.pageStack.pop()
            }
        }
    }
}