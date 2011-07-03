import QtQuick 1.0
//import Qt.labs.folderlistmodel 1.0
import "js/translator.js" as Translator

QtObject {

    signal retranslateRequired(string langId)

    /*
    property variant folder : ListView {
        model:  folderContent
    }

    property variant folderContent : FolderListModel {
        folder:  "js/translations"
        nameFilters: ["*"]
        showDirs: false
        showDotAndDotDot: false
        showOnlyReadable: true
    } */

    function initializeTranslation() {
        Translator.initializeTranslation();
    }

    function setLanguage(languageId) {
        Translator.setLanguage(languageId);
        retranslateRequired(languageId)
    }

    function translate(key, args) {
        console.log("translating " + key);
        var value = Translator.translate(key);

        if (arguments.length > 1)
        {
            for(var index=1; index<arguments.length; index++)
            {
                value = value.replace(eval("/%"+index+"/"), arguments[index]);
            }
        }
        return value;
    }

}
