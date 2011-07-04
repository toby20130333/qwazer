import QtQuick 1.0
import "js/Storage.js" as Storage

Rectangle {
    id: qwazerSettings
    anchors.fill: parent

    width: 700
    height: 400

    signal okClicked
    signal settingsLoaded
    signal retranslateRequired(string langId)
    signal mapRefreshRequested

    function initialize() {
        Storage.initialize();
        translator.initializeTranslation();
        qwazerSettings.state = "Loading";
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
    property variant language

    // {name:..., locale:..., lon: ... , lat:..., map_url:..., ws_url:...}
    property variant country

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

    Grid {
        id: grid1
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.topMargin: 10
        anchors.bottom: okButton.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottomMargin: 10

        columns: 2
        spacing: 10

        Text {
            id: languageLabel
            text: translator.translate("Language%1", ":") + mainView.forceTranslate
            font.pointSize: 20
        }

        Button {
            id: selectedLanguage
            text: ""

            onClicked: qwazerSettings.state = "SelectLanguageState"
        }

        Text {
            id: countryLabel
            text: translator.translate("Default Country%1", ":") + mainView.forceTranslate
            font.pointSize: 20
        }

        Button {
            id: selectedCountry
            text: ""

            onClicked: qwazerSettings.state = "SelectCountryState"
        }

        Text {
            id: nightModeLabel
            text: translator.translate("Night Mode (TODO)%1", ":") + mainView.forceTranslate
            font.pointSize: 20
        }

        ToggleButton {
            id: nightModeSelector
            text: isSelected? "+" : "-"
            isSelected: false
        }
    }

    ListView {
        id: languagesList
        anchors.fill: parent
        visible: false
        model: languagesModel

        currentIndex: findItem(languagesModel, language, "name")
        highlightFollowsCurrentItem: true
        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        focus: true

        delegate: Component {
            MouseArea {
                height: languageName.height
                width: languagesList.width
                Text {
                    id: languageName
                    text: name
                    font.pointSize: 32
                }

                onClicked: {
                    settings.language = {name: name, langId: langId, rtl: rtl};
                    qwazerSettings.state = "Loaded";
                }
            }
        }
    }

    ListView {
        id: countryList
        anchors.fill: parent
        visible: false
        model: countriesModel

        currentIndex: findItem(countriesModel, country, "name")
        highlightFollowsCurrentItem: true
        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        focus: true

        delegate: Component {
            MouseArea {
                height: countryName.height
                width: countryList.width
                Text {
                    id: countryName
                    text: name
                    font.pointSize: 32
                }

                onClicked: {
                    settings.country = {name: name, locale: locale, lon: lon, lat: lat, map_url: map_url, ws_url: ws_url};
                    qwazerSettings.state = "Loaded";
                }
            }
        }
    }

    Button {
        id: okButton
        text: "OK"
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10

        onClicked: qwazerSettings.okClicked()
    }


    states: [
        State {
            name: "Loading"
            PropertyChanges {
                target: qwazerSettings

                language: isValidValue(Storage.getSetting("Language"))? Storage.getObjectSetting("Language") : language
                onLanguageChanged : {
                    Storage.setObjectSetting("Language", language);
                    translator.setLanguage(language.langId);
                    retranslateRequired(language.langId);
                }

                isFirstRun: isValidValue(Storage.getSetting("IsFirstRun"))? Storage.getSetting("IsFirstRun") : isFirstRun
                lastKnownPosition: isValidValue(Storage.getSetting("LastKnownPosition"))? Storage.getObjectSetting("LastKnownPosition") : lastKnownPosition
                country: isValidValue(Storage.getSetting("Country"))? Storage.getObjectSetting("Country") : country
                zoom: isValidValue(Storage.getSetting("Zoom"))? Storage.getObjectSetting("Zoom") : zoom
                nightMode: isValidValue(Storage.getSetting("NightMode"))? Storage.getSetting("NightMode") : nightMode
                favoriteLocations: isValidValue(Storage.getSetting("FavoriteLocations"))? Storage.getObjectSetting("FavoriteLocations") : favoriteLocations
            }

            PropertyChanges {
                target: selectedCountry
                text: country.name
            }

            PropertyChanges {
                target: selectedLanguage
                text: language.name
            }

            PropertyChanges {
                target: nightModeSelector
                isSelected: nightMode
            }
        },
        State {
            name: "Loaded"
            extend: "Loading"

            PropertyChanges {
                target: qwazerSettings

                onIsFirstRunChanged : Storage.setSetting("IsFirstRun", isFirstRun)

                onLastKnownPositionChanged : Storage.setObjectSetting("LastKnownPosition", lastKnownPosition)

                onCountryChanged : {
                    var previousCountry = Storage.getSetting("Country");
                    Storage.setObjectSetting("Country", country);
                    lastKnownPosition = {lon: country.lon, lat: country.lat};
                    mapRefreshRequested();
                }

                onZoomChanged : Storage.setObjectSetting("Zoom", zoom)

                onNightModeChanged : isValidValue(Storage.getSetting("NightMode"))? Storage.setSetting("NightMode", nightMode) : nightMode

                onFavoriteLocationsChanged : Storage.setObjectSetting("FavoriteLocations", favoriteLocations)
            }
        },
        State {
            name: "SelectLanguageState"
            extend: "Loaded"

            PropertyChanges {
                target: languagesList
                visible: true
            }

            PropertyChanges {
                target: grid1
                visible: false
            }

            PropertyChanges {
                target: okButton
                visible: false
            }
        },
        State {
            name: "SelectCountryState"
            extend: "Loaded"

            PropertyChanges {
                target: countryList
                visible: true
            }

            PropertyChanges {
                target: grid1
                visible: false
            }

            PropertyChanges {
                target: okButton
                visible: false
            }
        }
    ]
}
