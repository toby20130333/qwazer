import QtQuick 1.0
import "js/Storage.js" as Storage

QtObject {
    function initialize() {
        Storage.initialize();
    }

    property bool isFirstRun : Storage.getSetting("IsFirstRun")
    onIsFirstRunChanged : Storage.setSetting("IsFirstRun", isFirstRun)

    property variant lastKnownPosition : Storage.getObjectSetting("LastKnownPosition")
    onLastKnownPositionChanged : Storage.setObjectSetting("LastKnownPosition", lastKnownPosition)

    property string language : Storage.getSetting("Language")
    onLanguageChanged : Storage.setSetting("Language", language)

    property string country : Storage.getSetting("Country")
    onCountryChanged : Storage.setSetting("Country", country)

    property variant favoriteLocations : Storage.getObjectSetting("FavoriteLocations")
    onFavoriteLocationsChanged : Storage.setObjectSetting("FavoriteLocations", favoriteLocations)
}
