
dialogue_open1 = false;
in_range1 = false;
dialogue_open2 = false;
in_range2 = false;

box_w = 230;
box_h = 60;

start_x = obj_player.x - box_w/2;
start_y = obj_player.y - box_h/2 - 50;

function update() {
	activate_dialogue1();
	close_dialogue1();
	check_in_range1();
	//show_debug_message(in_range1);
	activate_dialogue2();
	close_dialogue2();
	check_in_range2();
}

//npc1
function activate_dialogue1() {
	if (keyboard_check_pressed(vk_space) && in_range1) {
		audio_play_sound(snd_talk, 0, false);
		dialogue_open1 = true;
		start_x = obj_player.x - box_w/2;
		start_y = obj_player.y - box_h/2 - 50;
	}
}

function close_dialogue1() {
	if (abs(obj_player.x - obj_npc1.x) > 15 || abs(obj_player.y - obj_npc1.y) > 15) {
		dialogue_open1 = false;
	}
}

function check_in_range1() {
	if (abs(obj_player.x - obj_npc1.x) < 7 && abs(obj_player.x - obj_npc1.x) < 7) {
		in_range1 = true;
	}
	else {
		in_range1 = false;
	}
}

//npc2
function activate_dialogue2() {
	if (keyboard_check_pressed(vk_space) && in_range2) {
		audio_play_sound(snd_talk, 0, false);
		dialogue_open2 = true;
		start_x = obj_player.x - box_w/2;
		start_y = obj_player.y - box_h/2 - 50;
	}
}

function close_dialogue2() {
	if (abs(obj_player.x - obj_npc2.x) > 15 || abs(obj_player.y - obj_npc2.y) > 15) {
		dialogue_open2 = false;
	}
}

function check_in_range2() {
	if (abs(obj_player.x - obj_npc2.x) < 7 && abs(obj_player.x - obj_npc2.x) < 7) {
		in_range2 = true;
	}
	else {
		in_range2 = false;
	}
}