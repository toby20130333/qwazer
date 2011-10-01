import QtQuick 1.0

Item {

    function speakScenario(distance, opcode, arg)
    {
        wordsListModel.clear();

        var transcript = translator.getTranscriptFromScenario(distance, opcode, arg);
        for (var index = 0; index < transcript.length; index++)
        {
            console.log("appending: sounds/" + settings.language.langId + "/" + transcript[index] + ".ogg");
            wordsListModel.append({sndFile: "sounds/" + settings.language.langId + "/" + transcript[index] + ".ogg"});
        }

        playFirstSound();
    }

    function playFirstSound()
    {
        console.log("playing " + wordsListModel.get(0).sndFile);
        audioPlayback.source = wordsListModel.get(0).sndFile;
        wordsListModel.remove(0);
        audioPlayback.play();
    }

    Connections {
        target: audioPlayback
        onStopped: {
            if (wordsListModel.count > 0)
            {
                playFirstSound();
            }
        }
    }

    ListModel {
        id: wordsListModel
    }
}
