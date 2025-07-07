function draw_update() {
	draw_flower();
	draw_info();
	
}

function draw_info() {
	if (mouse_hover) {
		
		var _center_x = def_x + 50;
		var _center_y = def_y;
		var _hoffset = 50;
		draw_set_halign(fa_center);
		draw_set_color(c_white);
		
		draw_sprite_stretched(spr_box_4, 0, _center_x - string_width(flower_type)/2, 
		_center_y - 20, string_width(flower_type), string_height(flower_type) - 9);
		draw_set_font(fnt_dp_comic_small);
		draw_text(_center_x, def_y, flower_type);
		
		/*draw_sprite_stretched(spr_box_4, 0, _center_x - string_width(flower_type)/2 - 5, 
		_center_y - 10, string_width + 10, string_height + 10)*/
		draw_set_font(fnt_cnb_xsmall);
		draw_text(_center_x, def_y + 20, flower_desc);
		draw_text(_center_x, def_y + 30 + string_height(flower_desc), flower_status);
	}
	
}

function draw_flower() {
	draw_set_halign(fa_left);
	if (flower_type == "Lily") {
		x = def_x;
		y = def_y;
		draw_sprite(spr_lily_glassbottom, 0, x, y);
		draw_sprite(spr_lily_stem, 0, x, flower_y + float_offset*0.7 + 1);
		draw_sprite(spr_lily_water, 0, x, y);
		draw_sprite(spr_lily_glasstop, 0, x, y);
		draw_sprite_ext(spr_lily_leafleftbottom, 0, x - 12, flower_y + float_offset*0.4, 1, 1, 
				float_offset*1, c_white, 1);
		draw_sprite_ext(spr_lily_leaftopleft, 0, x - 12, flower_y + float_offset*0.4 - 4, 1, 1, 
		float_offset*1.2, c_white, 1);
		draw_sprite_ext(spr_lily_leafright, 0, x - 15, flower_y + float_offset*0.4 + 7, 1, 1, 
				float_offset*-1.4, c_white, 1);
		draw_sprite_ext(spr_lily_flowerbottom, 0, x, flower_y + float_offset*0.4, 1 + float_offset*-0.015, 
		1 + float_offset * -0.01, 
				0, c_white, 1);
		draw_sprite(spr_lily_flowertop, 0, x, flower_y + float_offset*0.7);

	}
}


draw_update();