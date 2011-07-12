import QtQuick 1.0
import com.meego 1.0
import "qwazer/search_qml"

Page {
    id:searchAddressPage
    width: 800
    height: 400

    tools: commonBackButtonToolbar


    FindResultsModel {
        id: findAddressModel
        onLoadDone: appWindow.pageStack.push(addressDetailsPage)
    }

    SelectedAddressDetailsPage {
        id: addressDetailsPage
    }

    Column {
        Label {
            text: "Enter address to find"
        }

        TextField {
            id: address
            width: searchAddressPage.width
            height: 50
        }


        Button {
            id: searchButton
            text: "Search Address"
            onClicked: findAddressModel.address = address.text
        }
    }
}
