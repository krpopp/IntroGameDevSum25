global.scene_queue = [test];
global.current_scene_index = 0;

transition_timer = 0;
scene_active = false;
cutscene = noone;
global.is_cutscene = false;

function load_scene(_scene_func) {
	with (obj_cb_text_engine) {
	    clear_dialogue();
	    _scene_func();
	    run_dialogue();
	}
}

function next_scene() {
	if (global.current_scene_index < array_length(global.scene_queue)) {
		scene_active = true;
		var _next = global.scene_queue[global.current_scene_index];
		global.current_scene_index++;
		obj_cb_text_engine.dialogue_index = 0;
		
		load_scene(_next);
		
	}
}

function update() {
    if (scene_active) {
        if (instance_exists(obj_cb_text_engine) && !obj_cb_text_engine.dialogue_running) {
            scene_active = false;
			if (instance_exists(cutscene)) {
				cutscene.fade_state = "out";
				obj_cb_test_script.cutscene = noone;
				global.is_cutscene = false;
			}
            transition_timer = 140; 
        }
    } else {
        transition();
    }
}

function transition() {
    if (transition_timer <= 0) {
        next_scene();
    } else {
        transition_timer--;
    }
}

function test() {
	with (obj_cb_text_engine) {
	
		add_text_elem(def_x, def_y, CB_Character.None, "idle", "Whoever you want to bring back... they must've been of great importance to you.");
		add_text_elem(def_x, def_y, CB_Character.None, "senti", "Unfortunately, everyone before you has collapsed within the first bullet.");
		add_text_elem(def_x, def_y, CB_Character.None, "senti", "Everything is so heavily Dealer sided, yet people just keeping coming in.");
		add_text_elem(def_x, def_y, CB_Character.None, "idle", "Let's just get on with the damn game. Again, I do sincerely apologize ahead of time.");
	}
}

function damage_response() {
	var _quantity = obj_cb_character.times_took_damage;
	with (obj_cb_text_engine) {
		if (_quantity == 1) {
			add_text_elem(def_x, def_y, CB_Character.None, "hurt", "Straight up jorking it right now");
			add_text_elem(def_x, def_y, CB_Character.None, "hurt", "I can't stop gooning");
		}
		else {
			add_text_elem(def_x, def_y, CB_Character.None, "hurt", "Uagh...");
		}
	}
}