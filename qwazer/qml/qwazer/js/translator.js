// generate translation file:
// langID=he && ( echo -e "var _translation_${langID}={};\n\nfunction get_translation_${langID}() {\n\treturn _translation_${langID};\n}\n";([ -e qwazer/qml/qwazer/js/translations/qwazer.${langID}.js ] && grep '_translation_he.*="' qwazer/qml/qwazer/js/translations/qwazer.${langID}.js;grep -R '\.translate[ ]*([ ]*"[^"]*"' qwazer/qml/ | sed 's/.*translate[ ]*([ ]*"\([^"]*\)".*/_translation_'${langID}'["\1"]="\1";/g') |sort -u ) >  qwazer/qml/qwazer/js/translations/qwazer.${langID}.js.new && mv qwazer/qml/qwazer/js/translations/qwazer.${langID}.js.new qwazer/qml/qwazer/js/translations/qwazer.${langID}.js

var _currentTranslation;
var _translations = [];

function initializeTranslation() {
    console.log("initializing translations"); //, found " + folder.count + " translations");

//    TODO - dynamic load of translations files
//    for (folder.currentIndex = 0; folder.currentIndex < folder.count; folder.currentIndex++)
//    {
//        var langIdPattern = /^qwazer\.([A-z]+)\.qml$/;
//        var translationFile = folder.currentItem.fileName;
//        console.log("found translation file: " + translationFile);
//        Qt.include(translationFile);
//        console.log("loaded translation file: " + translationFile);
//        var langId = translationFile.replace(langIdPattern, "$1");
//        var translation = eval("get_translation_" + langId+"()");
//        _translations[langId] = translation;
//        console.log("loaded translation for: " + langId);
//    }

    Qt.include("translations/qwazer.he.js");

    _currentTranslation = _translations["en"];
    _translations["he"] = get_translation_he();
}

function setLanguage(languageId) {
    console.log("language set requested: " + languageId);
    _currentTranslation = _translations[languageId];
    console.log("language was set");
}


function translate(key) {
    var value = key;
    if (typeof(_currentTranslation) != "undefined" && typeof(_currentTranslation[key]) != "undefined")
    {
        value = _currentTranslation[key];
    }

    return value;
}
