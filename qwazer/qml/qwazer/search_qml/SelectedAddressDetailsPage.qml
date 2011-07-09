import QtQuick 1.0
import "../common_qml"
Page {
    id: selectedAddress
    title: translator.translate("Address Details") + mainView.forceTranslate

    width:800
    height: 400

    toolbarRightItems: VisualItemModel {
        Flow {
            spacing: 10

            Button {
                text: translator.translate("Add Favorite") + mainView.forceTranslate
            }

            Button {
                text: translator.translate("Show") + mainView.forceTranslate
            }

            Button {
                text: translator.translate("Navigate") + mainView.forceTranslate
            }
        }
    }

    Column {
        anchors.fill: selectedAddress.content

        Text {
            text: "address"
        }
    }
}
