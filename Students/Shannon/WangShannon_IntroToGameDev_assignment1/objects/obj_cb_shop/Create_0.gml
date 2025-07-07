randomize();
global.gorechips = 50;

mouse_hover_index = -1;

// image index

bandage_image_index = 0;
medkit_image_index = 0;
painkiller_image_index = 0;

// rot animations
tilt_timer_gorechip = random_range(0, 2 * pi);
tilt_timer_bandage = random_range(0, 2 * pi);
tilt_timer_medkit = random_range(0, 2 * pi);
tilt_timer_painkiller = random_range(0, 2 * pi);

gorechip_rot = 0;
bandage_rot = 0;
medkit_rot = 0;
painkiller_rot = 0;

// sizes

bandage_scale = 1;
medkit_scale = 1;
painkiller_scale = 1;

// shop
shop_index = 0;
shop_light_timer = 0;

function update() {
	tilt_animation_gorechip();
	manage_item_properties();
	manage_item_sizes();
	buy_item();
	shop_animation();
}

function manage_item_properties() {
	for (var _i = 0; _i < ds_list_size(global.items_shop); _i++) {
		var _item = ds_list_find_value(global.items_shop, _i);
		
		if (instance_exists(_item)) {
			if (_i == 0) {
				if (_item.in_stock <= 0) {
					bandage_image_index = 1;
					bandage_rot = 0;
				}
				else {
					bandage_image_index = 0;
					tilt_animation_bandage();
					
				}	
			}
			else if (_i == 1) {
				if (_item.in_stock <= 0) {
					medkit_image_index = 1;
					medkit_rot = 0;
				}
				else {
					medkit_image_index = 0;
					tilt_animation_medkit();
					
				}	
			}
			if (_i == 2) {
				if (_item.in_stock <= 0) {
					painkiller_image_index = 1;
					painkiller_rot = 0;
				}
				else {
					painkiller_image_index = 0;
					tilt_animation_painkiller();
					
				}	
			}	
		}
	}
}

function buy_item() {
	if (mouse_hover_index != -1 && mouse_check_button_pressed(mb_left)) {
		var _item = ds_list_find_value(global.items_shop, mouse_hover_index);
		
		if (instance_exists(_item) && _item.in_stock > 0 && _item.cost <= global.gorechips
			&& ds_list_size(global.item_inventory) < 4) {
			_item.in_stock--;
			global.gorechips -= _item.cost;
			
			ds_list_add(global.item_inventory, _item);
		}
	}
}

function manage_item_sizes() {
	if (mouse_hover_index == 0) {
		bandage_scale = lerp(bandage_scale, 1.15, 0.2);
	}
	else {
		bandage_scale = lerp(bandage_scale, 1, 0.2);
	}
	
	if (mouse_hover_index == 1) {
		medkit_scale = lerp(medkit_scale, 1.15, 0.2);
	}
	else {
		medkit_scale = lerp(medkit_scale, 1, 0.2);
	}
	if (mouse_hover_index == 2) {
		
		painkiller_scale = lerp(painkiller_scale, 1.15, 0.2);
	}
	else {
		painkiller_scale = lerp(painkiller_scale, 1, 0.2);
	}
}

function tilt_animation_gorechip() {

	tilt_timer_gorechip += 0.03;
	gorechip_rot = sin(tilt_timer_gorechip) * 8;
	if (tilt_timer_gorechip > 2 * pi ) {
		tilt_timer_gorechip -= 2 * pi;
	}
}

function tilt_animation_bandage() { 

	tilt_timer_bandage += random_range(0.01, 0.03);
	bandage_rot = sin(tilt_timer_bandage) * 6;
	if (tilt_timer_bandage > 2 * pi ) {
		tilt_timer_bandage -= 2 * pi;
	}
}

function tilt_animation_medkit() {

	tilt_timer_medkit += random_range(0.01, 0.03);
	medkit_rot = sin(tilt_timer_medkit) * 6;
	if (tilt_timer_medkit > 2 * pi ) {
		tilt_timer_medkit -= 2 * pi;
	}
}

function tilt_animation_painkiller() {
	
	tilt_timer_painkiller += random_range(0.01, 0.03);
	painkiller_rot = sin(tilt_timer_painkiller) * 6;
	if (tilt_timer_painkiller > 2 * pi ) {
		tilt_timer_painkiller -= 2 * pi;
	}
}

function shop_animation() {
	if (global.card_interactable) {
		if (shop_light_timer > 0) {
			shop_light_timer--;
		}
		else {
			shop_index = shop_index == 1 ? 2 : 1;
			shop_light_timer = 35;
		}
	}
	else {
		shop_index = 0;
	}
}