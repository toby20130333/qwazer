// generate translation file:
// langID=he && ( echo -e "var _translation_${langID}={};\n\nfunction get_translation_${langID}() {\n\treturn _translation_${langID};\n}\n";([ -e qwazer/qml/qwazer/js/translations/qwazer.${langID}.js ] && grep '_translation_he.*="' qwazer/qml/qwazer/js/translations/qwazer.${langID}.js;grep -R '\.translate[ ]*([ ]*"[^"]*"' qwazer/qml/ | sed 's/.*translate[ ]*([ ]*"\([^"]*\)".*/_translation_'${langID}'["\1"]="\1";/g') |sort -u ) >  qwazer/qml/qwazer/js/translations/qwazer.${langID}.js.new && mv qwazer/qml/qwazer/js/translations/qwazer.${langID}.js.new qwazer/qml/qwazer/js/translations/qwazer.${langID}.js

var _langId;
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

    _translations["he"] = get_translation_he();

    setLanguage("en"); // set default to English
}

function setLanguage(languageId) {
    console.log("language set requested: " + languageId);
    _langId = languageId;
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

function getTranscriptFromScenario(distance, opcode, arg)
{
    var transcript = [];

    if (typeof(_currentTranscriber) == "undefined")
    {
        if (distance > 0)
        {
            transcript.push("in" + distance + "m");
        }

        if (opcode.indexOf("ROUNDABOUT") === 0)
        {
            if (opcode=="ROUNDABOUT_EXIT")
            {
                if (_langId == "en")
                {
                    transcript.push("ROUNDABOUT");
                    transcript.push("TAKE_THE");
                    transcript.push(arg);
                    transcript.push("EXIT");
                }
                else if (_langId == "he")
                {
                    transcript.push("ROUNDABOUT");
                    transcript.push("EXIT");
                    transcript.push(arg);
                }
            }
            else if (opcode=="ROUNDABOUT_EXIT_RIGHT")
            {
                transcript.push("ROUNDABOUT");
                transcript.push("TURN_RIGHT");
            }
            else if (opcode=="ROUNDABOUT_EXIT_LEFT")
            {
                transcript.push("ROUNDABOUT");
                transcript.push("TURN_LEFT");
            }
        }
        else if (opcode == "APPROACHING_DESTINATION")
        {
            transcript = transcript.concat(["DESTINATION"], transcript);
        }
        else
        {
            transcript.push(opcode);
        }
    }
    else
    {
        transcript = _currentTranscriber(distance, opcode, arg);
    }

    return transcript;
}
