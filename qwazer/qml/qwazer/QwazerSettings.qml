import QtQuick 1.0
import "js/Storage.js" as Storage

Rectangle {
    id: qwazerSettings
    anchors.fill: parent

    width: 700
    height: 400

    signal okClicked
    signal settingsLoaded

    function initialize() {
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
            name: "ישראל"
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
            text: "שפה:"
            font.pointSize: 20
        }

        Button {
            id: selectedLanguage
            text: ""

            onClicked: qwazerSettings.state = "SelectLanguageState"
        }

        Text {
            id: countryLabel
            text: "מדינת ברירת מחדל:"
            font.pointSize: 20
        }

        Button {
            id: selectedCountry
            text: ""

            onClicked: qwazerSettings.state = "SelectCountryState"
        }

        Text {
            id: nightModeLabel
            text: "מצב לילה:"
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
            name: "Loaded"
            PropertyChanges {
                target: qwazerSettings
                isFirstRun: isValidValue(Storage.getSetting("IsFirstRun"))? Storage.getSetting("IsFirstRun") : isFirstRun
                onIsFirstRunChanged : Storage.setSetting("IsFirstRun", isFirstRun)

                language: isValidValue(Storage.getSetting("Language"))? Storage.getObjectSetting("Language") : language
                onLanguageChanged : Storage.setObjectSetting("Language", language)

                country: isValidValue(Storage.getSetting("Country"))? Storage.getObjectSetting("Country") : country
                onCountryChanged : Storage.setObjectSetting("Country", country)

                lastKnownPosition: isValidValue(Storage.getSetting("LastKnownPosition"))? Storage.getObjectSetting("LastKnownPosition") : lastKnownPosition
                onLastKnownPositionChanged : Storage.setObjectSetting("LastKnownPosition", lastKnownPosition)

                zoom: isValidValue(Storage.getSetting("Zoom"))? Storage.getObjectSetting("Zoom") : zoom
                onZoomChanged : Storage.setObjectSetting("Zoom", zoom)

                nightMode: isValidValue(Storage.getSetting("NightMode"))? Storage.getSetting("NightMode") : nightMode
                onNightModeChanged : isValidValue(Storage.getSetting("NightMode"))? Storage.setSetting("NightMode", nightMode) : nightMode

                favoriteLocations: isValidValue(Storage.getSetting("FavoriteLocations"))? Storage.getObjectSetting("FavoriteLocations") : favoriteLocations
                onFavoriteLocationsChanged : Storage.setObjectSetting("FavoriteLocations", favoriteLocations)
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
