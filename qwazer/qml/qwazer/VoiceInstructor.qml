import QtQuick 1.0

Item {

    function speakScenario(distance, opcode, arg)
    {
        playWords.running = false;
        wordsListModel.clear();

        var transcript = translator.getTranscriptFromScenario(distance, opcode, arg);
        for (var index = 0; index < transcript.length; index++)
        {
            console.log("appending: " + "sounds/en/" + transcript[index] + ".ogg");
            wordsListModel.append({sndFile: "sounds/en/" + transcript[index] + ".ogg"});
//            wordsListModel.append({sndFile: "sounds/" + settings.language.id + "/" + transcript[index] + ".ogg"});
        }

        playWords.running = true;
    }

    ListModel {
        id: wordsListModel
    }

    Timer {
        id: playWords
        interval: 200
        repeat: false
        triggeredOnStart: true
        onTriggered: {
            if (wordsListModel.count > 0)
            {
                console.log("playing " + wordsListModel.get(0).sndFile);
                audioPlayback.source = wordsListModel.get(0).sndFile;
                wordsListModel.remove(0);
                audioPlayback.play();
            }
            else
            {
                console.log("calling stop");
                playWords.stop();
            }
        }
    }
}
