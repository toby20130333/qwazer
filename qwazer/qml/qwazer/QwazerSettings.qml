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

    function isValidValue(value)
    {
        return Storage.isValidValue(value);
    }

    // bool
    property bool isFirstRun : true

    // {lon: ..., lat:...}
    property variant lastKnownPosition


    property string languageName
    onLanguageNameChanged: {
        if (language === undefined || language.name != languageName) language = findItem(languagesModel, {name: languageName}, "name")
    }
    // {name:..., langId:..., rtl:...}
    property variant language : languagesModel.get(0)

    property string countryName
    onCountryNameChanged: {
        if (country === undefined || country.name != countryName) country = findItem(countriesModel, {name: countryName}, "name")
    }
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
