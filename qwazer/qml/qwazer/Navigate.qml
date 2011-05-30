import QtQuick 1.0

Rectangle {
    id: navigateView
    width: 800
    height: 400

    signal backButtonPressed

    Text {
        id: fromLabel
        text: "מהיכן:"
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 24
        anchors.right: fromSearch.right
    }

    Text {
        id: fromField
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
    }


}
