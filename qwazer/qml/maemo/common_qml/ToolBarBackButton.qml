import QtQuick 1.0

Button {
    id: backButtonPriv
    text: translator.translate("Back") + mainView.forceTranslate

    onClicked: backButtonClicked()
}
