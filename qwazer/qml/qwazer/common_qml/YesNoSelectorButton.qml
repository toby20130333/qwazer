import QtQuick 1.0

DualStateButton {
    id: booleanSelector

    property bool isSelected: selectedIndex == 0

    leftText: translator.translate("Yes") + mainView.forceTranslate
    rightText: translator.translate("No") + mainView.forceTranslate
    selectedIndex: isSelected? 0 : 1
    onSelectedIndexChanged: isSelected = (selectedIndex == 0);
}
