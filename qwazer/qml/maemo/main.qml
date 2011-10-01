import QtQuick 1.0
import "../qwazer"
import "../qwazer/search_qml"
import QtMultimediaKit 1.1

Rectangle {
    id: mainView

    width: 800
    height: 400

    property alias gpsData: gps.positionSource

    property Page __activePage2
    property Page activePage
    onActivePageChanged: {
        if (__activePage2 !== null)
        {
            __activePage2.visible = false;
        }
        activePage.visible = true;
        __activePage2 = activePage;
    }

    Component.onCompleted: {
        settingsLoadPage.visible = true;
        settings.initialize();
    }

    Audio {
        id: audioPlayback
        onError: console.log(errorString)
        volume: 1
    }

    GPSProvider {
        id: gps
    }

    QwazerSettings {
        id: settings

        onSettingsLoaded: {
            if (typeof(settings.isFirstRun) == "undefined" || settings.isFirstRun)
            {
                activePage = settingsPage;
            }
            else
            {
                qwazerMapView.initialize();
            }
        }
    }

    FindResultsModel {
        id: findAddressModel
        onLoadDone: activePage = addressResultsPage
        onAddressChanged: activePage = loadingResultsPage
    }

    CourseResultsListModel {
        id: courseResultsModel
        onLoadDone: activePage = courseResultsPage
    }

    Translator { id: translator }


    BusyPage {
        id: settingsLoadPage
        backText: ""
        backIcon: ""
        onBackClicked: {}
    }

    MapView {
        id: qwazerMapView

        onMapLoaded: activePage = qwazerMapView
        onSearchButtonClicked: activePage = searchPage
        onSettingsButtonClicked: activePage = settingsPage
    }

    SettingsPage {
        id: settingsPage

        onOkClicked: {
            if (settings.isFirstRun)
            {
                settings.isFirstRun = !settings.isFirstRun;
                qwazerMapView.initialize();
            }
            else
            {
               activePage = qwazerMapView;
            }
        }
    }

    SearchAddressPage {
        id: searchPage

        onBackButtonClicked: activePage = qwazerMapView
    }

    SelectedAddressDetailsPage {
        id: addressDetailsPage

        onAddressDetailsChanged: activePage = addressDetailsPage
        onBackButtonClicked: activePage = (searchPage.state == "Search") ? addressResultsPage : searchPage
    }

    BusyPage {
        id: loadingResultsPage

        text: translator.translate("Searching for address%1", "...") + translator.forceTranslate

        onBackClicked: {
            findAddressModel.cancelled = true;
            activePage = searchPage;
        }
    }

    BusyPage {
        id: coursePlottingBusyPage
        text: translator.translate("Plotting course%1", "...") + translator.forceTranslate
        backIcon: ""
        onBackClicked: {}

        property variant course
        onCourseChanged: {
            activePage = coursePlottingBusyPage;
            delayedWorker.running = true;
        }

        Timer {
            id: delayedWorker
            interval: 1000
            onTriggered: {
                qwazerMapView.navigate(coursePlottingBusyPage.course);
                activePage = qwazerMapView;
            }
            repeat: false
        }
    }

    BusyPage {
        id: courseCalcBusyPage

        text: translator.translate("Calculating Course%1", "...") + translator.forceTranslate

        onBackClicked: {
            cancelled = true;
            activePage = addressDetailsPage;
        }
    }

    AddressResultsPage {
        id: addressResultsPage
        onBackButtonClicked: activePage = searchPage
    }

    PathSelection {
        id: courseResultsPage
        onBackButtonClicked: activePage = addressDetailsPage
    }
}
