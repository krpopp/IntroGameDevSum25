draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(fnt_dp_comic);

var c_burgundy = make_colour_rgb(204,37,81);
draw_set_color(c_white);


var _x_center = 501;
var _y_start = 31;
var _dw_width = 128;
var _dw_height = 149;

draw_sprite_stretched(spr_box_6, 0, _x_center - 5, 43, 42, 25);
draw_text(_x_center + 17, 41, string(global.gorechips));

draw_sprite_ext(spr_gorechip_flat, 0, _x_center - 27, _y_start + 24, 1, 1, gorechip_rot + 5, c_white, 1);

// shop items

var _rows = 3;
var _cols = 2;
var _box_w = 45;
var _box_h = 28;
var _spacing_x = 4;
var _spacing_y = 3;

var _total_w = _cols * _box_w + (_cols - 1) * _spacing_x;
var _total_h = _rows * _box_h + (_rows - 1) * _spacing_y;

var _grid_x = _x_center - _total_w / 2;
var _grid_y = _y_start + 44;

var _i = 0;
mouse_hover_index = -1;

for (var row = 0; row < _rows; row++) {
	for (var col = 0; col < _cols; col++) {
		if (_i >= ds_list_size(global.items_shop)) break;

		var _x = _grid_x + col * (_box_w + _spacing_x);
		var _y = _grid_y + row * (_box_h + _spacing_y);
		
		//var _item_id = global.items_unlocked[| _i];
		var _item = ds_list_find_value(global.items_shop, _i);
		
		var _offset = 5;
		//mouse hover
		if (point_in_rectangle(mouse_x, mouse_y, _x + _offset, _y + _offset, _x + _box_w - _offset, 
		_y + _box_h - _offset) && !obj_cb_text_engine.dialogue_running) {
			mouse_hover_index = _i;
		}
		
		if (instance_exists(_item) && _item.unlocked && _item.in_stock > 0) {
			draw_sprite_stretched(spr_box_8, 0, _x, _y, _box_w, _box_h);
		} else {
			draw_sprite_stretched(spr_box_8, 1, _x, _y, _box_w, _box_h);
			//show_debug_message("grey");
		}
		
		if (instance_exists(_item) && _item.unlocked) {
			if (_item.unlocked && _item.item_index == 0) {
				draw_sprite_ext(spr_shop_bandage, bandage_image_index, _x + 22, _y + 13, bandage_scale, 
				bandage_scale, -bandage_rot, c_white, 1);
			}
			else if (_item.unlocked && _item.item_index == 1) {
				draw_sprite_ext(spr_shop_medkit, medkit_image_index, _x + 22, _y + 13, medkit_scale, 
				medkit_scale, medkit_rot, c_white, 1);
			}
			else if (_item.unlocked && _item.item_index == 2) {
				draw_sprite_ext(spr_shop_painkiller, painkiller_image_index, _x + 22, _y + 13, painkiller_scale, 
				painkiller_scale, painkiller_rot, c_white, 1);
			}
			
			// out of stock
			draw_set_font(fnt_dp_comic_small);
			if (_item.in_stock <= 0) {
				draw_set_color(c_burgundy);
				draw_text(_x + 23, _y + 5, "OUT");
			}
		}
		else {
			draw_sprite_ext(spr_shop_lock_icon, 0, _x + 22, _y + 13, 1, 1, 0, c_white, 1);
		}
		
		
		_i++;
	}
}

// shop border
draw_sprite_stretched(spr_shop_box, shop_index, _x_center - _dw_width/2 - 10, 21, _dw_width + 20, _dw_height + 20);

// tool tip when hovering over item
if (mouse_hover_index != -1) {
	var _item = ds_list_find_value(global.items_shop, mouse_hover_index);
	if (instance_exists(_item)) {

		var _box_w_item = 100;
		var _box_h_item = 60;

		var _row = mouse_hover_index div _cols;
		var _col = mouse_hover_index mod _cols;
		var _x = _grid_x + _col * (_box_w + _spacing_x);
		var _y = _grid_y + _row * (_box_h + _spacing_y);


		var _tooltip_x = _x + _box_w_item / 2 - 50;
		var _tooltip_y = _y + _box_h_item - 29;

		draw_sprite_stretched(spr_box_9, 0, _tooltip_x, _tooltip_y, _box_w_item, _box_h_item);

		draw_set_halign(fa_center);
		draw_set_valign(fa_top);
		draw_set_font(fnt_cnb_xsmall);
		draw_set_color(c_white);
		
		var _tooltip_center = _tooltip_x + _box_w_item/2;

		// name
		draw_text(_tooltip_center, _tooltip_y + 10, _item.item_name);
		
		// in stock
		if (_item.in_stock > 0) {
			draw_set_color(c_white);
			draw_text(_tooltip_center, _tooltip_y + 25, "IN STOCK: " + string(_item.in_stock));
		} else {
			draw_set_color(c_burgundy);
			draw_text(_tooltip_center, _tooltip_y + 25, "OUT OF STOCK");
		}

		// price
		var _price_x = _tooltip_center;
		var _price_y = _tooltip_y + 40;

		var _price_label = "PRICE: ";
		var _price_value = string(_item.cost);

		draw_set_color(c_white);
		draw_text(_price_x, _price_y, _price_label);

		var _label_width = string_width(_price_label);
		
		// the actual number
		var _price_color = global.gorechips >= _item.cost ? c_white : c_burgundy;
		draw_set_color(_price_color);
		draw_text(_price_x + _label_width - 25, _price_y, _price_value);

	}
}
