import QtQuick 1.0

Rectangle {
    id: navigateView
    width: 800
    height: 400

    signal backButtonPressed

    Rectangle {
        id: rectangle2
        x: 538
        y: 60
        width: 236
        height: 55
        color: "#ffffff"
        border.color: "black"

        TextInput {
            id: fromSearchText
            text: ""
            horizontalAlignment: TextInput.AlignRight
            anchors.fill: parent
            font.pixelSize: 24
        }
    }

    Rectangle {
        id: rectangle1
        x: 126
        y: 61
        width: 266
        height: 54
        color: "#ffffff"
        border.color: "black"

        TextInput {
            id: toSearchText
            text: ""
            anchors.fill: parent
            horizontalAlignment: TextInput.AlignRight
            font.pixelSize: 24
        }
    }

    Button {
        id: searchFromButton
        x: 437
        y: 60
        width: 96
        height: 55
        text: "חפש"
        onClicked: {
            fromResultsModel.address = fromSearchText.text;
        }
    }

    Button {
        id: searchToButton
        x: 21
        y: 61
        width: 97
        height: 55
        text: "חפש"
        onClicked: {
            toResultsModel.address = toSearchText.text;
        }
    }

    Text {
        id: whereLabel
        x: 695
        y: 12
        width: 80
        height: 20
        text: "מהיכן:"
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 24
    }

    Text {
        id: toLabel
        x: 312
        y: 13
        width: 80
        height: 20
        text: "לאן:"
        font.pixelSize: 24
        horizontalAlignment: Text.AlignRight
    }



    FindResultsModel {
        id: fromResultsModel
    }

    Component {
        id: fromResultsDelegate
        Row {
            spacing: 10
             Text {
                 text: name
                 horizontalAlignment: Text.AlignRight
                 font.pointSize: 24
             }
             Button {
                 text: "בחר"
                 onClicked: {
                     selectedFrom.text = name;
                 }
             }
        }
    }

    Rectangle {
        id: rectangle4
        x: 20
        y: 128
        width: 373
        height: 207
        color: "#ffffff"
        border.color: "black"

        ListView {
            id: fromResultList
            anchors.fill: parent
            model: toResultsModel.dataModel
            delegate: toResultsDelegate
        }
    }

    FindResultsModel {
        id: toResultsModel
    }

    Component {
        id: toResultsDelegate
        Row {
            spacing: 10
             Text {
                 text: name
                 horizontalAlignment: Text.AlignRight
                 font.pointSize: 24
             }
             Button {
                 text: "בחר"
                 onClicked: {
                     selectedTo.text = name;
                 }
             }
        }
    }

    Rectangle {
        id: rectangle3
        x: 437
        y: 128
        width: 338
        height: 209
        color: "#ffffff"
        border.color: "black"

        ListView {
            id: toResultList
            anchors.fill: parent
            model: fromResultsModel.dataModel
            delegate: fromResultsDelegate
        }
    }

    Rectangle {
        id: rectangle5
        x: 435
        y: 12
        width: 271
        height: 40
        color: "#ffffff"

        Text {
            id: selectedFrom
            text: ""
            horizontalAlignment: Text.AlignRight
            anchors.fill: parent
            font.pixelSize: 24
        }
    }

    Rectangle {
        id: rectangle6
        x: 21
        y: 13
        width: 324
        height: 39
        color: "#ffffff"

        Text {
            id: selectedTo
            text: ""
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 24
        }
    }

    Button {
        id: navigateButton
        x: 22
        y: 346
        width: 373
        height: 53
        text: "נווט"
    }

    Button {
        id: backButton
        x: 437
        y: 347
        width: 339
        height: 52
        text: "חזרה"
        onClicked: navigateView.backButtonPressed()
    }
}
