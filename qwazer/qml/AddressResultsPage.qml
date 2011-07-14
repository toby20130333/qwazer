import QtQuick 1.0
import com.meego 1.0
import "qwazer/search_qml"

Page {
    id: addressResults

    tools: commonBackButtonToolbar

    SelectedAddressDetailsPage {
        id: addressDetailsPage
    }

    Rectangle {
        id: resultsRect
        color: "#00000000"
        radius: 10
        anchors.fill: parent
        border.color: "#000000"


        ListView {
            id: resultsListView
            model: findAddressModel.dataModel
            anchors.fill: resultsRect
            clip: true
            delegate: Rectangle {
                id: row
                border.color: "black"
                radius: 10
                width: mainText.width
                height: mainText.height
                Label {
                    id: mainText
                    text: name
                    width: resultsListView.width
                    height: font.pointSize * 3
                }
                MouseArea {
                    anchors.fill: row
                    onClicked: {
                        var o = findAddressModel.dataModel.get(index);
                        appWindow.pageStack.push(addressDetailsPage,
                                                 {name: o.name,
                                                 location: o.location,
                                                 phone: o.phone? o.phone:"",
                                                 url: o.url? o.url:"",
                                                 businessName: o.businessName? o.businessName:""});
                    }
                }
            }
        }
    }

}
