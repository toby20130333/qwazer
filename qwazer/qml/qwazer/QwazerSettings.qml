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

    // {name:..., locale:...}
    property variant country : countriesModel.get(0)

    // bool
    property bool nightMode : false

    property variant favoriteLocations

    ListModel {
        id: countriesModel

        ListElement {
            name: "World"
            locale: ""
            location.lon: -73.96731
            location.lat: 40.78196
        }
        ListElement {
            name: "ישראל"
            locale: "israel"
            location.lon : 34.78975
            location.lat : 32.08662
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
                    font.pointSize: 20
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

        delegate: Component {
            MouseArea {
                height: countryName.height
                width: countryList.width
                Text {
                    id: countryName
                    text: name
                }

                onClicked: {
                    settings.country = {name: name, locale: locale, location: {lon: location.lon, lat: location.lat}};
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

                lastKnownPosition: isValidValue(Storage.getSetting("LastKnownPosition"))? Storage.getObjectSetting("LastKnownPosition") : country.location
                onLastKnownPositionChanged : Storage.setObjectSetting("LastKnownPosition", lastKnownPosition)

                nightMode: Storage.getSetting("NightMode")
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
