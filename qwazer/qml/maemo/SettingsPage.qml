import QtQuick 1.0

Rectangle {
    id: settingsPage
    anchors.fill: parent

    width: 700
    height: 400

    signal okClicked
    signal settingsLoaded
    signal retranslateRequired(string langId)
    signal mapRefreshRequired

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
            text: translator.translate("Language%1", ":") + translator.forceTranslate
            font.pointSize: 20
        }

        Button {
            id: selectedLanguage
            text: settings.language.name

            onClicked: settingsPage.state = "SelectLanguageState"
        }

        Text {
            id: countryLabel
            text: translator.translate("Default Country%1", ":") + translator.forceTranslate
            font.pointSize: 20
        }

        Button {
            id: selectedCountry
            text: settings.country.name

            onClicked: settingsPage.state = "SelectCountryState"
        }

        Text {
            id: nightModeLabel
            text: translator.translate("Night Mode (TODO)%1", ":") + translator.forceTranslate
            font.pointSize: 20
        }

        ToggleButton {
            id: nightModeSelector
            text: isSelected? "+" : "-"
            isSelected: settings.nightMode
        }
    }

    ListView {
        id: languagesList
        anchors.fill: parent
        visible: false
        model: languagesModel

        currentIndex: findItem(languagesModel, settings.language, "name")
        highlightFollowsCurrentItem: true
        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        focus: true
        clip: true

        delegate: Component {
            Button {
                width: languagesList.width
                text: name
                onClicked: {
                    settings.language = {name: name, langId: langId, rtl: rtl};
                    settingsPage.state = "Loaded";
                }
            }
        }
    }

    ListView {
        id: countryList
        anchors.fill: parent
        visible: false
        model: countriesModel

        currentIndex: findItem(countriesModel, settings.country, "name")
        highlightFollowsCurrentItem: true
        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        focus: true
        clip: true

        delegate: Component {
            Button {
                width: countryList.width
                text: name

                onClicked: {
                    settings.country = {name: name, locale: locale, lon: lon, lat: lat, map_url: map_url, ws_url: ws_url};
                    settingsPage.state = "Loaded";
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

        onClicked: settingsPage.okClicked()
    }


    states: [
        State {
            name: "Loaded"

            PropertyChanges {
                target: languagesList
                visible: false
            }

            PropertyChanges {
                target: countryList
                visible: false
            }

            PropertyChanges {
                target: grid1
                visible: true
            }

            PropertyChanges {
                target: okButton
                visible: true
            }
        },
        State {
            name: "SelectLanguageState"

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
