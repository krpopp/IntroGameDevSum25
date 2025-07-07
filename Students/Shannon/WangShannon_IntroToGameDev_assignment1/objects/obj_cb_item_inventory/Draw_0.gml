draw_set_halign(fa_center);

inventory_hover_index = -1;

for (var i = 0; i < 4; i++) {
	var _item = ds_list_find_value(global.item_inventory, i);
	if (!instance_exists(_item)) continue;


	var _item_x = item_x[i];
	var _item_y = item_y[i];
	var _scale = item_scale[i];
	var _img_index = round(item_image_index[i]);
	
	// hitbox
	var _offset = 35;
	var _hb_left = _item_x - _offset;
	var _hb_top = _item_y - _offset;
	var _hb_right = _item_x + _offset;
	var _hb_bottom = _item_y + _offset;
		
	if (point_in_rectangle(mouse_x, mouse_y, _hb_left, _hb_top, _hb_right, _hb_bottom)
	&& !obj_cb_text_engine.dialogue_running) {
		inventory_hover_index = i;
	}

	// draw
	if (_item.item_index == 0) {
		draw_sprite_ext(spr_item_bandage, _img_index, _item_x, _item_y, _scale, _scale, 0, c_white, 1);
	}
	else if (_item.item_index == 1) {
		draw_sprite_ext(spr_item_medkit, _img_index, _item_x, _item_y, _scale, _scale, 0, c_white, 1);
	}
	else if (_item.item_index == 2) {
		draw_sprite_ext(spr_item_painkiller, _img_index, _item_x, _item_y, _scale, _scale, 0, c_white, 1);
	}
}

		