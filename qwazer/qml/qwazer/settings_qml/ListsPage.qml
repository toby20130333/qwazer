import QtQuick 1.0
import "../common_qml"

Page {
    id: listsPage

    Rectangle {
        id: rectangle1
        color: "#ffffff"
        anchors.fill: listsPage.content
        border.color: "black"


        ListView {
            id: languagesList
            anchors.fill: parent
            visible: false
            model: languagesModel
            clip: true

            currentIndex: findItem(languagesModel, language, "name")
            highlightFollowsCurrentItem: true
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            focus: true

            delegate: Component {
                Rectangle {
                    height: languageName.height
                    width: languagesList.width
                    Text {
                        id: languageName
                        text: name
                        font.pointSize: 32
                    }
                }
            }
        }

        ListView {
            id: countryList
            anchors.fill: parent
            visible: false
            model: countriesModel
            clip: true

            currentIndex: findItem(countriesModel, country, "name")
            highlightFollowsCurrentItem: true
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            focus: true

            delegate: Component {
                Rectangle {
                    height: countryName.height
                    width: countryList.width
                    Text {
                        id: countryName
                        text: name
                        font.pointSize: 32
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "CountrySelectionState"
            PropertyChanges {
                target: languagesList
                visible: false
            }
            PropertyChanges {
                target: countryList
                visible: true
            }
            PropertyChanges {
                target: listsPage
                title: translator.translate("Country%1", ":") + mainView.forceTranslate
                onMoveToPrevPage: {
                    var selectedCountry = countryList.highlightItem;
                    settings.country = {name: selectedCountry.name, locale: selectedCountry.locale, lon: selectedCountry.lon, lat: selectedCountry.lat, map_url: selectedCountry.map_url, ws_url: selectedCountry.ws_url};
                }
            }
        },
        State {
            name: "LanguageSelectionState"
            PropertyChanges {
                target: languagesList
                visible: true
            }
            PropertyChanges {
                target: countryList
                visible: false
            }
            PropertyChanges {
                target: listsPage
                title: translator.translate("Language%1", ":") + mainView.forceTranslate
                onMoveToPrevPage: {
                    var selectedLanguage = languagesList.highlightItem;
                    settings.language = {name: selectedLanguage.name, langId: selectedLanguage.langId, rtl: selectedLanguage.rtl};
                }
            }
        }
    ]

}
