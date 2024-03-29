import QtQuick 1.0
import "js/Storage.js" as Storage

Item {
    id: qwazerSettings

    signal okClicked
    signal settingsLoaded
    signal mapRefreshRequired

    function initialize() {
        translator.initializeTranslation();
        Storage.initialize();
        qwazerSettings.state = "Loaded";
        settingsLoaded();
        console.log("settings loaded successfully");
    }

    function findItem(model, item, field)
    {
        for (var index = 0; index < model.count; index++)
        {
            var element = model.get(index);
            console.log("checking " + element[field] + " if match to " + item);
            if ((field && element[field] == item[field]) || element == item  )
            {
                console.log("return " + element[field])
                return element;
            }
        }

       return model.get(0);
    }

    function findItemIndex(model, item, field)
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

    function addFavoriteLocation(details)
    {
        favoriteLocations.append(details);
        return Storage.addFavorite(details);
    }

    function removeFavoriteLocation(name)
    {
        var index = findItemIndex(favoriteLocations, {name: name}, "name");
        console.log("removing from favorites list model at index " + index);
        favoriteLocations.remove(index);
        return Storage.removeFavorite(name);
    }

    function isFavoriteLocation(name)
    {
        return Storage.isFavorite(name);
    }

    // bool
    property bool isFirstRun : true

    // {lon: ..., lat:...}
    property variant lastKnownPosition

    property string languageName : languagesModel.get(0).name
    property variant language : languagesModel.get(0)

    property string countryName : countriesModel.get(0).name
    property variant country : countriesModel.get(0)

    // bool
    property bool nightMode : false

    // int
    property int zoom : 8

    // bool
    property bool navigationFullscreenInstruction : true

    // bool
    property bool navigationNorthLocked : false

    // bool
    property bool navigationScreenStaysLit : true

    // bool
    property bool navigationShowNextTurns : true

    property ListModel favoriteLocations : ListModel {}

    property ListModel countriesModel : ListModel {
        ListElement {
            name: "World"
            locale: "world"
            lon: 2.29449
            lat: 48.85825
            map_url: "http://world.waze.com/wms-c"
            ws_url: "http://world.waze.com"
            maxZoom: 15
        }
        ListElement {
            name: "US & Canada"
            locale: "us"
            lon: -73.96731
            lat: 40.78196
            map_url: "http://www.waze.com/wms-c"
            ws_url: "http://www.waze.com"
            maxZoom: 15
        }
        ListElement {
            name: "Israel"
            locale: "israel"
            lon: 34.78975
            lat: 32.08662
            map_url: "http://ymap1.waze.co.il/wms-c"
            ws_url: "http://www.waze.co.il"
            maxZoom: 10
        }
    }

    property ListModel languagesModel : ListModel {
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

                languageName: isValidValue(Storage.getSetting("LanguageName"))? Storage.getSetting("LanguageName") : languageName
                onLanguageNameChanged: {
                    Storage.setSetting("LanguageName", languageName);
                    language = findItem(languagesModel, {name: languageName}, "name");
                    translator.setLanguage(language.langId);
                }

                countryName: isValidValue(Storage.getSetting("CountryName"))? Storage.getSetting("CountryName") : countryName
                onCountryNameChanged : {
                    var previousCountryName = Storage.getSetting("CountryName");
                    country = findItem(countriesModel, {name: countryName}, "name");
                    Storage.setSetting("CountryName", countryName);
                    if (!isValidValue(previousCountryName) ||  previousCountryName != countryName)
                    {
                        lastKnownPosition = {lon: country.lon, lat: country.lat};
                        mapRefreshRequired();
                    }
                }

                lastKnownPosition: isValidValue(Storage.getSetting("LastKnownPosition"))? Storage.getObjectSetting("LastKnownPosition") : lastKnownPosition
                onLastKnownPositionChanged : Storage.setObjectSetting("LastKnownPosition", lastKnownPosition)

                zoom: isValidValue(Storage.getSetting("Zoom"))? Storage.getSetting("Zoom") : zoom
                onZoomChanged : Storage.setSetting("Zoom", zoom)

                nightMode: isValidValue(Storage.getBooleanSetting("NightMode"))? Storage.getBooleanSetting("NightMode") : false
                onNightModeChanged : Storage.setBooleanSetting("NightMode", nightMode)

                navigationFullscreenInstruction: isValidValue(Storage.getBooleanSetting("NavigationFullscreenInstruction"))? Storage.getBooleanSetting("NavigationFullscreenInstruction") : true
                onNavigationFullscreenInstructionChanged : Storage.setBooleanSetting("NavigationFullscreenInstruction", navigationFullscreenInstruction)

                navigationNorthLocked: isValidValue(Storage.getBooleanSetting("NavigationNorthLocked"))? Storage.getBooleanSetting("NavigationNorthLocked") : false
                onNavigationNorthLockedChanged : Storage.setBooleanSetting("NavigationNorthLocked", navigationNorthLocked)

                navigationScreenStaysLit: isValidValue(Storage.getBooleanSetting("NavigationScreenStaysLit"))? Storage.getBooleanSetting("NavigationScreenStaysLit") : true
                onNavigationScreenStaysLitChanged : Storage.setBooleanSetting("NavigationScreenStaysLit", navigationScreenStaysLit)

                navigationShowNextTurns: isValidValue(Storage.getBooleanSetting("NavigationShowNextTurns"))? Storage.getBooleanSetting("NavigationShowNextTurns") : true
                onNavigationShowNextTurnsChanged : Storage.setBooleanSetting("NavigationShowNextTurns", navigationShowNextTurns)
            }
        }
    ]
}
