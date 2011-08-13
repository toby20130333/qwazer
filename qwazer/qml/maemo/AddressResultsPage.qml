import QtQuick 1.0
import "../qwazer"
import "../qwazer/search_qml"
import "../qwazer/js/Images.js" as Images

Page {
    id: searchResultsPage
    width: 300
    height: 300
    anchors.fill: parent

    signal backButtonClicked
    signal selected(variant selection)

    tools: VisualItemModel {
           Flow {
               id: addressResultsToolBar
               IconButton {
                   iconSource: Images.back
                   text: translator.translate("Back") + translator.forceTranslate
                   onClicked: backButtonClicked()
               }
           }
       }

    content: VisualItemModel {
        Rectangle {
            id: resultsRect
            color: "#00000000"
            anchors.fill: parent
            border.color: "#000000"

            Text {
                id: addressResultsLabel
                text: translator.translate("Address Search Results") + translator.forceTranslate
                font.pointSize: 24
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10
            }

            Rectangle {
                id: rectangle2
                color: "#ffffff"
                border.color: "#000000"
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.top: addressResultsLabel.bottom
                anchors.bottom: parent.bottom
                radius: 10

                anchors.margins: 10

                ListView {
                    id: resultsListView
                    model: findAddressModel.dataModel
                    anchors.fill: parent
                    boundsBehavior: ListView.StopAtBounds
                    clip: true
                    delegate: ListItem {
                        text: name
                        width: resultsListView.width
                        onClicked: {
                            var o = findAddressModel.dataModel.get(index);
                            if (typeof(addressDetailsPage.addressDetails) == "undefined" ||
                                addressDetailsPage.addressDetails.name != o.name)
                            {
                                addressDetailsPage.addressDetails =  {name: o.name,
                                        location: o.location,
                                        phone: o.phone? o.phone:"",
                                        url: o.url? o.url:"",
                                        businessName: o.businessName? o.businessName:""};
                            }
                            else
                            {
                                addressDetailsPage.addressDetailsChanged();
                            }
                        }
                    }
                }
            }
        }
    }
}
