
global.item_inventory = ds_list_create();
inventory_hover_index = -1;

// image properties
item_image_index = [0, 0, 0, 0];
item_scale = [1, 1, 1, 1];
base_scales = [1, 1.3, 0.7, 1, 1];

// flash animation properties

prev_inventory_size = 0;
item_buy_flash = [false, false, false, false];
item_buy_timer = [0, 0, 0, 0];

// item positions
item_x = [530, 590, 540, 600];
item_y = [257, 270, 307, 320];
item_y_target = [257, 270, 307, 320];

function update() {
	hover_over_item();
	check_new_inventory_items();
}


function hover_over_item() {
	for (var i = 0; i < 4; i++) {
		var _item = ds_list_find_value(global.item_inventory, i);
		
		if (!instance_exists(_item)) continue;

		var _hovered = (i == inventory_hover_index);
		
		var _hover_target_y = item_y_target[i] + (_hovered ? -15 : 0);
		var _hover_scale = base_scales[_item.item_index] + (_hovered ? 0.2 : 0);
		var _image_index = _hovered ? 2 : 0;

		item_y[i] = lerp(item_y[i], _hover_target_y, 0.3);
		item_scale[i] = lerp(item_scale[i], _hover_scale, 0.3);
		item_image_index[i] = lerp(item_image_index[i], _image_index, 0.3);

	}

}

function spawn_item(_i) {
	var _item = ds_list_find_value(global.item_inventory, _i);
	
	if (instance_exists(_item)) {
		var _base_scale = base_scales[_item.item_index];

		item_scale[_i] = _base_scale + 0.3;

		item_buy_flash[_i] = true;
		item_buy_timer[_i] = 10;
	}
}

function check_new_inventory_items() {
	var current_size = ds_list_size(global.item_inventory);

	for (var i = 0; i < current_size; i++) {
		if (i >= prev_inventory_size) {
			item_buy_flash[i] = true;
			item_buy_timer[i] = 10;
			spawn_item(i);
		}
	}

	prev_inventory_size = current_size;
}
