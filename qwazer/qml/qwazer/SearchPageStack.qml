import QtQuick 1.0
import "common_qml"
import "search_qml"

PageStack {
    id: searchPageStack

    signal backButtonPressed
    signal addressSelected(variant address)

    pages: VisualItemModel {
        SearchPage {
            onMoveToPrevPage: searchPageStack.backButtonPressed()
            onAddressSelected: searchPageStack.addressSelected(address)
        }

        SelectedAddressDetailsPage {

        }
    }
}
