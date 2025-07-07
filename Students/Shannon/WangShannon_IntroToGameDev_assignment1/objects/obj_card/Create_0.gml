visible = false;
image_xscale = 0.75;
image_yscale = 0.25;
image_speed = 0;
image_alpha = 1;

card_state = "shuffle";
flip_state = "back"; // back, flipping, front

// starting card pos, and current pos
card_x = 50;
card_y = -40;

// base target of pile
pile_x = 50;
pile_y = 300;

// base target of hand
hand_x = room_width/2;
hand_y = 350;

// play pos

play_x = room_width/2;
play_y = room_height/2;

// interaction
mouse_hover = false;
global.card_interactable = false;

card_type = "EYE";
card_desc = "Description";
card_type_index = 1;

// tilt
tilt_timer = 0;
tilt_direction = 1;

// burn on use

burn_timer = 0;
burn_progress = 0;
burn_speed = 0.01;
burning = false;

// on use
used = false;

function assign_card_type_index() {
	if (card_type == "HEARTBEAT I") {
		card_type_index = 1;
		card_desc = "";
	}
	else if (card_type == "HEARTBEAT II") {
		card_type_index = 2;
	}
	else if (card_type == "RIBCAGE I") {
		card_type_index = 3;
	}
	else if (card_type == "RIBCAGE II") {
		card_type_index = 4;
	}
	else if (card_type == "EYEBALL") {
		card_type_index = 5;
	}
	else if (card_type == "BRAINSTEM") {
		card_type_index = 6;
	}
	else if (card_type == "STOMACH") {
		card_type_index = 7;
	}
	else if (card_type == "TRANSPLANT") {
		card_type_index = 8;
	}
	else if (card_type == "DOUBLE OR NOTHING") {
		card_type_index = 9;
	}
	else if (card_type == "BLOODLUST") {
		card_type_index = 10;
	}
	else if (card_type == "REVOLVER") {
		card_type_index = 11;
	}
}

function update() {
	switch_card_state();
	flip_card();
	manage_card_y_position();
	tilt_animation();
	check_if_played();
}

function switch_card_state() {

	switch (card_state) {
		case "shuffle":
			break;
		case "to_pile":
			x = lerp(x, card_x, 0.1);
			y = lerp(y, card_y, 0.1);
			image_yscale = lerp(image_yscale, 0.75, 0.1);
			
			if (card_x == pile_x && card_y == pile_y) {
				card_state = "pile";
			}
			break;
		case "pile":
			// pile animation
			break;
		case "to_hand":
			depth = 500;
			x = lerp(x, hand_x, 0.1);
			y = lerp(y, hand_y, 0.1);
			
			card_x = hand_x;
			card_y = hand_y;
			
			if (abs(x - hand_x) < 1 && abs(y - hand_y) < 1) {
				card_state = "hand";
			}
			break;
		case "hand":
			depth = 600;
			if (image_index == 0) {
				flip_state = "flipping";
			}
			
			if (card_x != hand_x) {
				card_state = "to_hand";
			}
			
			if ((mouse_x >= hand_x - sprite_width/2 && mouse_x <= hand_x + sprite_width/2)
				&& (mouse_y >= hand_y - sprite_height/2 && mouse_y <= hand_y + sprite_height/2)) {
				mouse_hover = true;
			}
			else {
				mouse_hover = false;
			}
			
			if (obj_cb_text_engine.panel_state == "closed" && y <= 310 && global.played_card == noone
			&& global.ready_to_play == global.max_hand_size) {
				global.card_interactable = true;
				
			} else {
				global.card_interactable = false;
			}

			break;
			
		case "play": 
			depth = 500;
		
			x = lerp(x, play_x, 0.1);
			y = lerp(y, play_y, 0.1);
			image_xscale = lerp(image_xscale, 0.9, 0.1);
			image_yscale = lerp(image_yscale, 0.9, 0.1);
			
			if (abs(x - play_x) < 0.01 && abs(y - play_y) < 0.01) {
				card_state = "burn";
			}
			
		break;
		case "burn":
		// temp fade instead of burn effect
			if (image_alpha > 0) {
				image_alpha -= 0.02;
			}
			else {
				be_used();
				//use_timer = 180;
			}
		
		break;
		case "discard": break;
	}
}

function flip_card() {
	switch (flip_state) {
		case "back":
			image_index = 0;
			break;
		case "flipping":
			if (image_index == 0) {
				image_xscale = lerp(image_xscale, 0.1, 0.3);
				image_yscale = lerp(image_yscale, 0.9, 0.3);
				if (image_xscale < 0.15) {
					image_index = card_type_index;
				}
			}
			else {
				image_xscale = lerp(image_xscale, 0.75, 0.3);
				image_yscale = lerp(image_yscale, 0.75, 0.3);
				if (image_xscale == 0.75) {
					card_state = "hand";
					global.ready_to_play++;
					flip_state = "front";
				}
			}
			break;
		case "front":
			// nothing
			break;
	}
}

function manage_card_y_position() {
	if (card_state == "hand") {
		if (global.weapon_in_use) {
			y = lerp(y, hand_y + 130, 0.05); //offscreen when weapon in use
		}
		else if (obj_cb_text_engine.panel_state != "closed") {
			y = lerp(y, hand_y + 27, 0.1);
		}
		else {
			if (mouse_hover && global.card_interactable) {
				y = lerp(y, hand_y - 25, 0.03);
			}
			else {
				y = lerp(y, hand_y, 0.03);
			}
		}
	}
}


function tilt_animation() {
	if (card_state == "hand" && mouse_hover && global.card_interactable) {
		tilt_timer += 0.85;
		image_angle = sin(tilt_timer) * 1.5;
		if (tilt_timer >= 2 * pi) {
			tilt_timer -= 2 * pi;
		}
	} 
	if (card_state == "hand" || card_state == "to_hand") {
		tilt_timer += 0.05;
		image_angle = sin(tilt_timer) * 2;
		if (tilt_timer >= 2 * pi) {
			tilt_timer -= 2 * pi;
		}
	} else {
		image_angle = lerp(image_angle, 0, 0.2);
	}
}

function check_if_played() {
	if (mouse_hover && global.card_interactable && mouse_check_button_pressed(mb_left)
		&& global.played_card == noone) {
		card_state = "play";
		play();
		
	}
}

function play() {
	
	global.played_card = id;
	
	with (obj_card_manager) {
		play_card();
	}

}

function be_used() {
	if (!used && card_type == "REVOLVER") {
		used = true;
		with (obj_weapon_controller) {
			spawn_revolver();
		}
	}
		
}