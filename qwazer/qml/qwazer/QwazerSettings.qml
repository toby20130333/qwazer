import QtQuick 1.0
import "js/Storage.js" as Storage
import "common_qml"
import "settings_qml"

PageStack {
    id: qwazerSettings

    pages: VisualItemModel {
        MainSettingsPage {
            id: mainSettingsPage
            width: qwazerSettings.width
            height: qwazerSettings.height
            title: translator.translate("Settings") + mainView.forceTranslate

            languageName: language.name
            countryName: country.name
            nightModeSelected: nightMode

            onMoveToPrevPage: okClicked()
            onMoveToNextPage: qwazerSettings.moveToNextPage(nextState)
        }

        ListsPage {
            id: listsPage
            title: "list"
            width: qwazerSettings.width
            height: qwazerSettings.height
            onMoveToPrevPage: qwazerSettings.moveToPrevPage("")
        }
    }

    signal okClicked
    signal settingsLoaded
    signal retranslateRequired(string langId)
    signal mapRefreshRequired

    function initialize() {
        translator.initializeTranslation();
        Storage.initialize();
        qwazerSettings.state = "Loaded";
        settingsLoaded();
    }

    function findItem(model, item, field)
    {
        for (var index = 0; index < model.count; index++)
        {
            if ((field && model.get(index)[field] == item[field]) || model.get(index) == item  )
            {
                return index;
            }
        }

       return 0;
    }

    function isValidValue(value)
    {
        return Storage.isValidValue(value);
    }

    // bool
    property bool isFirstRun : true

    // {lon: ..., lat:...}
    property variant lastKnownPosition

    // {name:..., langId:..., rtl:...}
    property variant language : languagesModel.get(0)

    // {name:..., locale:..., lon: ... , lat:..., map_url:..., ws_url:...}
    property variant country : countriesModel.get(0)

    // bool
    property bool nightMode : false

    // int
    property int zoom : 8

    property variant favoriteLocations

    ListModel {
        id: countriesModel

        ListElement {
            name: "World"
            locale: ""
            lon: -73.96731
            lat: 40.78196
            map_url: "http://www.waze.com/wms-c"
            ws_url: "http://www.waze.com"
        }
        ListElement {
            name: "Israel"
            locale: "israel"
            lon: 34.78975
            lat: 32.08662
            map_url: "http://ymap1.waze.co.il/wms-c"
            ws_url: "http://www.waze.co.il"
        }
    }

    ListModel {
        id: languagesModel

        ListElement {
            name: "English"
            langId: "en"
            rtl: false
        }
        ListElement {
            name: "עברית"
            langId: "he"
            rtl: true
        }
    }

    states: [
        State {
            name: "Loaded"
            PropertyChanges {
                target: qwazerSettings

                isFirstRun: isValidValue(Storage.getBooleanSetting("IsFirstRun"))? Storage.getBooleanSetting("IsFirstRun") : isFirstRun
                onIsFirstRunChanged : Storage.setBooleanSetting("IsFirstRun", isFirstRun)

                language: isValidValue(Storage.getSetting("Language"))? Storage.getObjectSetting("Language") : language
                onLanguageChanged : {
                    Storage.setObjectSetting("Language", language);
                    translator.setLanguage(language.langId);
                    retranslateRequired(language.langId);
                }

                country: isValidValue(Storage.getSetting("Country"))? Storage.getObjectSetting("Country") : country
                onCountryChanged : {
                    var previousCountry = Storage.getObjectSetting("Country");

                    if (!isValidValue(previousCountry) ||  previousCountry.name != country.name)
                    {
                        Storage.setObjectSetting("Country", country);
                        lastKnownPosition = {lon: country.lon, lat: country.lat};
                        mapRefreshRequired();
                    }
                }

                lastKnownPosition: isValidValue(Storage.getSetting("LastKnownPosition"))? Storage.getObjectSetting("LastKnownPosition") : lastKnownPosition
                onLastKnownPositionChanged : Storage.setObjectSetting("LastKnownPosition", lastKnownPosition)

                zoom: isValidValue(Storage.getSetting("Zoom"))? Storage.getSetting("Zoom") : zoom
                onZoomChanged : Storage.setSetting("Zoom", zoom)

                nightMode: isValidValue(Storage.getBooleanSetting("NightMode"))? Storage.getBooleanSetting("NightMode") : nightMode
                onNightModeChanged : Storage.setBooleanSetting("NightMode", nightMode)
            }
        }
    ]
}
