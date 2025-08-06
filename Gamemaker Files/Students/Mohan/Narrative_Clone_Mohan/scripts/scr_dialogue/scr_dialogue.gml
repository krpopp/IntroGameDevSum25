function show_dialogue(npc, text) {
    global.textbox.visible = true;
    global.textbox.npc_instance = npc;
    global.textbox.txt = text;
    audio_play_sound(snd_talk, 1, false);
}

function hide_dialogue() {
    global.textbox.visible = false;
}