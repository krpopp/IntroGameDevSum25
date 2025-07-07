randomize();

card_initial_queue = ds_list_create();
global.card_pile_stack = ds_stack_create();
global.card_hand_list = ds_list_create();

global.max_hand_size = 5;
global.ready_to_play = 0;

pile_timer = 120;
global.played_card = noone;


// on use
use_timer = -1;

// add card to initial deck (before shuffling)
function deck_add(_card_type, _quantity) {
	var _x = 50;
	var _y = -40;
	for (var _i = 0; _i < _quantity; _i++) {
		var _card = instance_create_layer(_x, _y, "Cards", obj_card);
		_card.card_type = _card_type;
		with (_card) {
			assign_card_type_index();
		}
		ds_list_add(card_initial_queue, _card);
		
	}
}

function shuffle_cards(_list) {
	var _size = ds_list_size(_list);
	for (var _i = _size - 1; _i > 0; _i--) {
		var _j = irandom(_i);
		var _temp = _list[| _i];
		_list[| _i] = _list[| _j];
		_list[| _j] = _temp;
	}
}

function pile_add(_card) {
	ds_stack_push(global.card_pile_stack, _card);
}

// pushes shuffled cards into card stack
function lerp_into_pile(_stack) {
	var _spacing = 0.5;
	var _base_x = 50;
	var _base_y = 300;
	var _stack_height = 0;
	var _offset = 0;
	
	while (!ds_list_empty(card_initial_queue)) {
		var _card = card_initial_queue[| 0];
		ds_list_delete(card_initial_queue, 0);

		if (instance_exists(_card)) {
			_card.card_x = _base_x;
			_card.card_y = _base_y - _stack_height;
			_card.visible = true;
			_card.alarm[0] = _offset;
			_offset += 2;
			_card.depth -= _stack_height;
			_stack_height += _spacing;

			pile_add(_card);
		}
	}
}

function draw_card(_stack) { // manual drawing
	ds_list_add(global.card_hand_list, ds_stack_pop(global.card_pile_stack));
}

function fill_hand() {
	if (ds_list_size(global.card_hand_list) < global.max_hand_size) {
		
		var _offset = 1;
		var _depth_change = 1;
		var _cards_to_draw = global.max_hand_size - ds_list_size(global.card_hand_list);
		
		for (var _i = 0; _i < _cards_to_draw; _i++) {
			var _card = ds_stack_pop(global.card_pile_stack);
			var _prev_card = ds_list_find_value(global.card_hand_list, ds_list_size(global.card_hand_list));
			if (instance_exists(_card)) {
				ds_list_add(global.card_hand_list, _card);
			}
			/*if (instance_exists(_prev_card) && instance_exists(_card)) {
				_card.depth = _prev_card.depth - 100;
			}*/
			_card.depth -= _depth_change;
			_card.alarm[1] = _offset;
			_offset += 15;
			_depth_change += 1;
			
		}
	}
}

function play_card() {
	var _card_index = ds_list_find_index(global.card_hand_list, global.played_card);
	show_debug_message(_card_index);
	if (_card_index != -1) {
		ds_list_delete(global.card_hand_list, _card_index);
	}
	show_debug_message(ds_list_size(global.card_hand_list));
}

function update() {
	manage_hand();
	check_hand_empty();
	use_timer_manager();
}

function manage_hand() {
	if (!ds_exists(global.card_hand_list, ds_type_list)) {
		return;
	}

	var count = ds_list_size(global.card_hand_list);
	if (count == 0) { return; }

	var spacing = 72; 
	var center_x = room_width / 2;
	var base_y = 300;
	
	var total_width = (count - 1) * spacing;
	var start_x = center_x - total_width / 2;

	for (var _i = 0; _i < count; _i++) {
		var _card = global.card_hand_list[| _i];

		if (instance_exists(_card)) {
			_card.hand_x = start_x + _i * spacing;
			_card.hand_y = base_y;
			
			if (_card.card_state == "pile") {
				_card.card_state = "to_hand";
			}
		}
	}
}

function check_hand_empty() {
	/*if (ds_list_size(global.card_hand_list) == 0 && ds_stack_size(global.card_pile_stack) == 32) {
		fill_hand();
	}*/
	if (pile_timer > 0 && ds_list_size(global.card_hand_list) == 0) {
		pile_timer--;
	}
	else if (global.played_card == noone && obj_cb_text_engine.panel_state == "closed"
		&& !global.weapon_in_use) {
		fill_hand();
		pile_timer = 120;
	}
}

function use_timer_manager() {
	if (global.played_card != noone) {
		if (use_timer > 0) {
			use_timer--;
		}
		else if (use_timer == 0) {
			global.played_card = noone;
			use_timer = -1;
		}
		else {
			use_timer = -1;
		}
	}
}

//test push
/*deck_add("EYEBALL", 4);
deck_add("STOMACH", 4)
deck_add("HEARTBEAT I", 4);
deck_add("HEARTBEAT II", 2);
deck_add("RIBCAGE I", 4);
deck_add("RIBCAGE II", 2);
deck_add("BRAINSTEM", 4);
deck_add("TRANSPLANT", 4);
deck_add("DOUBLE OR NOTHING", 2);
deck_add("BLOODLUST", 2);
deck_add("REVOLVER", 4);*/

deck_add("REVOLVER", 10);


shuffle_cards(card_initial_queue);
lerp_into_pile(card_initial_queue);


