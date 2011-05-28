import QtQuick 1.0

Rectangle {
    id: searchView
    width: 780
    height: 400

    signal backButtonPressed
    signal addressSelected(variant address)

    Button {
        id: searchButton
        text: "חפש"
        x: 57
        y: 25
        width: 89
        height: 49
        onClicked: {
            console.log('before set address');
            findModel.address = searchTextField.text;
            console.log('after set address');
        }
    }

    Rectangle {
        id: rectangle1
        x: 172
        y: 24
        width: 521
        height: 51
        color: "white"
        border.color: "black"

        TextInput {
            id: searchTextField
            text: ""
            cursorVisible: true
            anchors.rightMargin: 5
            anchors.fill: parent
            horizontalAlignment: TextInput.AlignRight
            font.pixelSize: 24
        }
    }

    FindResultsModel {
        id: findModel
    }

    Component {
        id: searchResultsDelegate
        Row {
            spacing: 10
             Text {
                 text: name
                 horizontalAlignment: Text.AlignRight
                 font.pointSize: 24
             }
             Button {
                 text: "הצג"
                 onClicked: {
                     addressSelected({"name": name, "lon": lon, "lat": lat});
                     backButtonPressed();
                 }
             }
        }
    }

    Rectangle {
        id: rectangle2
        x: 57
        y: 92
        width: 638
        height: 231
        color: "white"
        border.color: "black"
        ListView {
            id: resultsListView
            anchors.fill: parent
            focus: true
            delegate: searchResultsDelegate
            model: findModel.dataModel
        }
    }
    Button {
        id: backButton
        x: 57
        y: 338
        width: 638
        height: 53
        text: "חזרה"
        onClicked: backButtonPressed()
    }

}
