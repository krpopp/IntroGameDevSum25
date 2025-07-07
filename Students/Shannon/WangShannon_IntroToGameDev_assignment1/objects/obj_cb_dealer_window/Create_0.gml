dealer_max_hp = 225;
dealer_hp = dealer_max_hp;
//dealer_hp = 200;

health_bar_w = dealer_hp/dealer_max_hp;
delayed_health_bar_w = 1;

center_x = room_width/2;
box_width = 230;
c_burgundy = make_colour_rgb(204,37,81);

global.dealer_defeated_bloodshed = false;


// dealer hb blood particle stuff.. cried about built in adjustments not working so manually did it
part_dealer_hb_system = part_system_create();
part_dealer_hb_type = part_type_create();

part_type_blend(part_dealer_hb_type, false);
part_type_sprite(part_dealer_hb_type, spr_dealer_health_particle, false, false, false);
part_type_size(part_dealer_hb_type, 0.3, 0.5, 0, 0);
part_type_color1(part_dealer_hb_type, c_burgundy);
part_type_alpha3(part_dealer_hb_type, 1, 0.7, 0.3);
part_type_direction(part_dealer_hb_type, 85, 105, 0, 2);
part_type_gravity(part_dealer_hb_type, 0.3, 270);
part_type_speed(part_dealer_hb_type, 2, 4, 0, 0);
part_type_life(part_dealer_hb_type, 200, 400);

dealer_emitter = part_emitter_create(part_dealer_hb_system);

part_timer = 0;

function hb_bleed(_amount) {
	part_timer = _amount*0.75;
	
}

function update() {
	lerp_health_bar();
	particle_activate();
	check_if_dead();
}

function lerp_health_bar() {
	health_bar_w = dealer_hp/dealer_max_hp;
	delayed_health_bar_w = lerp(delayed_health_bar_w, health_bar_w, 0.04);
}

function particle_activate() {
	
	var _x = center_x + (box_width/2 - 7) * delayed_health_bar_w;
	var _y = 31;
	
	
	if (part_timer > 0) {
		part_emitter_region(part_dealer_hb_system, dealer_emitter, _x, _x, _y, _y, ps_shape_line, ps_distr_linear);
		part_emitter_stream(part_dealer_hb_system, dealer_emitter, part_dealer_hb_type, 3);

		part_timer--;
	}
	else {
		part_timer = 0;
		part_emitter_stream(part_dealer_hb_system, dealer_emitter, part_dealer_hb_type, 0);
	}
	
}

function check_if_dead() {
	if (health_bar_w == 0) {
		global.dealer_defeated_bloodshed = true;
		
		with (obj_card) {
			visible = false;
		}
		with (obj_cb_shop) {
			visible = false;
		}
		with (obj_cb_signature_flower) {
			visible = false;
		}
		with (obj_holter_dot) {
			visible = false;
		}
		with (obj_cb_item) {
			visible = false;
		}
		with (obj_cb_left_window) {
			visible = false;
		}
		with (obj_cb_player_health) {
			visible = false;
		}
	}
	if (delayed_health_bar_w == 0) {
		room_goto(cutscene_bartender_death);
	}
}