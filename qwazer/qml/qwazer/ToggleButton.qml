import QtQuick 1.0

Button {
    id: toggleButton

    onClicked: isSelected = !isSelected

    property bool isSelected : true

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: !toggleButton.isSelected ? activePalette.light : activePalette.button
        }
        GradientStop {
            position: 1.0
            color: !toggleButton.isSelected ? activePalette.button : activePalette.dark
        }
    }

    SystemPalette { id: activePalette }
}
