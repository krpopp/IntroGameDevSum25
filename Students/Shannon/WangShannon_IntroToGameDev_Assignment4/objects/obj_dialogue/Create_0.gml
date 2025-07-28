global.dialogue_open1 = false;
in_range1 = false;
global.dialogue_open2 = false;
in_range2 = false;
global.dialogue_open3 = false;
in_range3 = false;


global.chocolate_bought = false;

box_w = 230;
box_h = 60;

start_x = obj_player.x - box_w/2;
start_y = obj_player.y + box_h/2 + 80;

depth = -800;

function update() {
	activate_dialogue1();
	close_dialogue1();
	check_in_range1();
	activate_dialogue2();
	close_dialogue2()
	check_in_range2()
	activate_dialogue3();
	close_dialogue3();
	check_in_range3();
	set_start();
}

//npc1
function activate_dialogue1() {
	if (keyboard_check_pressed(vk_space) && in_range1 && !global.dialogue_open1) {
		audio_play_sound(snd_talk, 0, false);
		global.dialogue_open1 = true;
		global.cult_invite = false;
	}
}

function close_dialogue1() {
	if ((abs(obj_player.x - obj_npc1.x) > 30 || abs(obj_player.y - obj_npc1.y) > 30) && global.dialogue_open1) {
		global.dialogue_open1 = false;
	}
}

function check_in_range1() {
	if (abs(obj_player.x - obj_npc1.x) < 30 && abs(obj_player.x - obj_npc1.x) < 30) {
		in_range1 = true;
	}
	else {
		in_range1 = false;
	}
}

//npc2

function activate_dialogue2() {
	if (keyboard_check_pressed(vk_space) && in_range2 && !global.dialogue_open2) {
		audio_play_sound(snd_talk, 0, false);
		global.dialogue_open2 = true;
	}
}

function close_dialogue2() {
	if ((abs(obj_player.x - obj_npc2.x) > 30 || abs(obj_player.y - obj_npc2.y) > 30) && global.dialogue_open2) {
		global.dialogue_open2 = false;
		global.cult_invite = false;
	}
}

function check_in_range2() {
	if (abs(obj_player.x - obj_npc2.x) < 30 && abs(obj_player.x - obj_npc2.x) < 30) {
		in_range2 = true;
	}
	else {
		in_range2 = false;
	}
}


//npc3
function activate_dialogue3() {
	if (keyboard_check_pressed(vk_space) && in_range3 && !global.dialogue_open3) {
		audio_play_sound(snd_talk, 0, false);
		global.dialogue_open3 = true;
	}
}

function close_dialogue3() {
	if ((abs(obj_player.x - obj_npc3.x) > 30 || abs(obj_player.y - obj_npc3.y) > 30) && global.dialogue_open3) {
		global.dialogue_open3 = false;
		global.cult_invite = false;
	}
}

function check_in_range3() {
	if (abs(obj_player.x - obj_npc3.x) < 30 && abs(obj_player.x - obj_npc3.x) < 30) {
		in_range3 = true;
	}
	else {
		in_range3 = false;
	}
}

function set_start() {
	start_x = obj_player.x - box_w/2;
	start_y = obj_player.y + box_h/2 + 80;
}