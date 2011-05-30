import QtQuick 1.0

Rectangle {
    id: searchView
    width: 780
    height: 400

    signal backButtonPressed
    signal addressSelected(variant address)

    SearchListControl {
        id: searchControl
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottom: backButton.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        onSelected: {
            addressSelected(selection);
            backButtonPressed();
        }
    }

    Button {
        id: backButton
        height: 50
        text: "חזרה"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.right: searchControl.left
        anchors.left: searchControl.right
        onClicked: backButtonPressed()
    }

}
