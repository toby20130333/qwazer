import QtQuick 1.0
import "../common_qml"

Page {
    id: listsPage

    onMoveToPrevPage: qwazerSettings.moveToPrevPage("")

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
            currentIndex: findItem(languagesModel, qwazerSettings.language, "name")
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
                    onClicked: settings.language = {name: name, langId: langId, rtl: rtl};
                }
            }
        }

        ListView {
            id: countryList
            anchors.fill: parent
            visible: false
            model: countriesModel
            clip: true
            currentIndex: findItem(countriesModel, qwazerSettings.country, "name")
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

                    onClicked: settings.country = {name: name, locale: locale, lon: lon, lat: lat, map_url: map_url, ws_url: ws_url};
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
            }
        }
    ]

}
