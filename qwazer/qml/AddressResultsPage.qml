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
        clip: true

        ListView {
            id: resultsListView
            model: findAddressModel.dataModel
            anchors.fill: resultsRect
            delegate:
                Row {

                    Label {
                        id: mainText
                        text: name
                        width: resultsListView.width
                        height: font.pointSize * 3
                        z: 1

                        MouseArea {
                            anchors.fill: mainText
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
                    Rectangle {
                        id: rect1
                        border.color: "black"
                        anchors.fill: mainText
                        radius: 10
                        z: -1
                    }


               }
        }
    }

}
