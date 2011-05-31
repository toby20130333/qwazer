import QtQuick 1.0

Rectangle {
    id: navigateView
    width: 800
    height: 400

    signal backButtonPressed
    signal navigateRequested(variant fromToPoints)

    property variant from
    property variant to

    Text {
        id: fromLabel
        text: "מהיכן:"
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 24
        anchors.right: fromSearch.right
    }

    Text {
        id: fromField
        text: (navigateView.from != null)? navigateView.from.name : ""

        horizontalAlignment: Text.AlignRight
        font.pointSize: 24

        anchors.right:fromLabel.left
        anchors.rightMargin: 10
        anchors.left: fromSearch.left
    }

    Text {
        id: toLabel
        text: "לאן:"
        font.pixelSize: 24
        anchors.right: toSearch.right
        horizontalAlignment: Text.AlignRight
    }

    Text {
        id: toField
        text: (navigateView.to != null)? navigateView.to.name : ""

        horizontalAlignment: Text.AlignRight
        font.pointSize: 24

        anchors.right:toLabel.left
        anchors.rightMargin: 10
        anchors.left: toSearch.left
    }

    SearchListControl {
        id: fromSearch

        width: parent.width/2-20
        anchors.top: fromField.bottom
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: backButton.top
        anchors.bottomMargin: 10

        onSelected: {
            fromField.text = selection.name;
            navigateView.from = selection;
        }
    }

    SearchListControl {
        id: toSearch

        width: parent.width/2-20
        anchors.top: toField.bottom
        anchors.topMargin: 10
        anchors.bottom: navigateButton.top
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10

        onSelected: {
            toField.text = selection.name;
            navigateView.to = selection;
        }
    }

    Button {
        id: backButton
        text: "חזרה"
        onClicked: navigateView.backButtonPressed()

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.right: fromSearch.right
        anchors.left: fromSearch.left
    }

    Button {
        id: navigateButton
        text: "נווט"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.right: toSearch.right
        anchors.left: toSearch.left

        onClicked: navigateRequested(
                       {from:{lon: navigateView.from.lon,
                              lat: navigateView.from.lat},
                        to:{lon: navigateView.to.lon,
                            lat: navigateView.to.lat}}
                       )
    }


}
