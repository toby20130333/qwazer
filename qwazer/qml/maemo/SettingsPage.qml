import QtQuick 1.0
import "../qwazer"
import "../qwazer/js/Images.js" as Images

Page {
    id: settingsPage
    anchors.fill: parent

    width: 700
    height: 400

    signal okClicked
    signal settingsLoaded
    signal retranslateRequired(string langId)
    signal mapRefreshRequired

    content: VisualItemModel {
        Column {
            id: settingsColumn
            spacing: 30
            anchors.fill: parent
            anchors.margins: 30

            Text {
                id: generalSettingsLabel
                text: translator.translate("General application settings%1", ":") + translator.forceTranslate
                font.underline: true
            }

            Grid {
                id: generalSettingsGrid
                columns: 2
                spacing: 20

                Text {
                    text: translator.translate("Language%1", ":") + translator.forceTranslate
                }

                Button {
                    text: settings.languageName
                    onClicked: languagesList.visible = true
                    width: 250
                }

                Text {
                    text: translator.translate("Default Country%1", ":") + translator.forceTranslate
                }

                Button {
                    text: settings.countryName
                    onClicked: countryList.visible = true
                    width: 250
                }

                Text {
                    text: translator.translate("Night Mode (TODO)%1", ":") + translator.forceTranslate
                }

                Switch {
                    checked: settings.nightMode
                    onCheckedChanged: settings.nightMode = checked
                }
            }

            Text {
                id: navigationSettingsLabel
                text: translator.translate("Navigation Settings%1", ":") + translator.forceTranslate
                font.underline: true
            }

            Grid {
                id: navigationSettingsGrid
                columns: 2
                spacing: 20

                Text {
                    text: translator.translate("Fullscreen instructions%1", ":") + translator.forceTranslate
                }

                Switch {
                    checked: settings.navigationFullscreenInstruction
                    onCheckedChanged: settings.navigationFullscreenInstruction = checked
                }

                Text {
                    text: translator.translate("North Locked%1", ":") + translator.forceTranslate
                }

                Switch {
                    checked: settings.navigationNorthLocked
                    onCheckedChanged: settings.navigationNorthLocked = checked
                }

                Text {
                    text: translator.translate("Show Next Turns%1", ":") + translator.forceTranslate
                }

                Switch {
                    checked: settings.navigationShowNextTurns
                    onCheckedChanged: settings.navigationShowNextTurns = checked
                }

                Text {
                    text: translator.translate("Screen stays lit%1", ":") + translator.forceTranslate
                }

                Switch {
                    checked: settings.navigationScreenStaysLit
                    onCheckedChanged: settings.navigationScreenStaysLit = checked
                }
            }
        }
    }

    tools: VisualItemModel {
        Flow {
            id: settingsToolBar
            anchors.margins: 20
            IconButton {
                id: okButton
                text: translator.translate("Back") + translator.forceTranslate
                iconSource: Images.back

                onClicked: settingsPage.okClicked()
            }

            DualStateButton {
                id: settingsState
                anchors.verticalCenter: settingsToolBar.verticalCenter
                leftText: translator.translate("General") + translator.forceTranslate
                rightText: translator.translate("Navigation") + translator.forceTranslate
            }
        }
    }

    Menu {
        id: languagesList

        onBackButtonClicked: languagesList.visible = false

        menuItems: VisualItemModel {
                ListView {
                    id: langButtonList
                    anchors.fill: parent
                    model: settings.languagesModel

                    currentIndex: settings.findItemIndex(settings.languagesModel, settings.language, "name")
                    highlightFollowsCurrentItem: true
                    highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
                    focus: true
                    clip: true

                    delegate: Component {
                        ListItem {
                            text: name
                            width: langButtonList.width
                            onClicked: {
                                settings.languageName = name;
                                languagesList.visible = false;
                            }
                        }
                    }
                }
            }
    }

    Menu {
        id: countryList

        onBackButtonClicked: countryList.visible = false

        menuItems: VisualItemModel {
                ListView {
                    id: countryButtonList
                    anchors.fill: parent
                    model: settings.countriesModel

                    currentIndex: settings.findItemIndex(settings.countriesModel, settings.country, "name")
                    highlightFollowsCurrentItem: true
                    highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
                    focus: true
                    clip: true

                    delegate: Component {
                        ListItem {
                            width: countryButtonList.width
                            text: name
                            onClicked: {
                                settings.countryName = name;
                                countryList.visible = false;
                            }
                        }
                    }
                }
            }
    }

    states: [
        State {
            name: "General"
            when: settingsState.selectedIndex == 0
            PropertyChanges {
                target: generalSettingsLabel
                visible: true
            }
            PropertyChanges {
                target: generalSettingsGrid
                visible: true
            }
            PropertyChanges {
                target: navigationSettingsLabel
                visible: false
            }
            PropertyChanges {
                target: navigationSettingsGrid
                visible: false
            }
        },
        State {
            name: "Navigation"
            when: settingsState.selectedIndex == 1
            PropertyChanges {
                target: generalSettingsLabel
                visible: false
            }
            PropertyChanges {
                target: generalSettingsGrid
                visible: false
            }
            PropertyChanges {
                target: navigationSettingsLabel
                visible: true
            }
            PropertyChanges {
                target: navigationSettingsGrid
                visible: true
            }
        }
    ]
}
