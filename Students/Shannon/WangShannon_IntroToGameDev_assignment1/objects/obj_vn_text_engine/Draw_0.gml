//var box_x = 80;
//var box_y = room_height - 100;
//var box_w = 380;
//var box_h = 80;

////replace this with working nine slices obj_box
//draw_set_color(c_black);
//draw_rectangle(box_x, box_y, box_x + box_w, box_y + box_h, false);
//draw_set_color(c_white);
//draw_rectangle(box_x, box_y, box_x + box_w, box_y + box_h, true);
if (panel_state == "closed"){exit;}

var _clamped_width = panel_width;
var _clamped_height = panel_height;

if (panel_state == "opening" || panel_state == "closing") {
    _clamped_width = max(panel_width, 40);
    _clamped_height = max(panel_height, 40);
}

draw_sprite_stretched(spr_box, 0, panel_x - _clamped_width / 2, panel_y - _clamped_height / 2, _clamped_width, _clamped_height);

if (text_line_ready && !text_is_choice){
	var _xmod = abs(sin(2*get_timer()/300000))*5
	draw_arrow(
	panel_x+(final_width/2)-36-_xmod,
	panel_y+(final_height/2)-32,
	panel_x+(final_width/2)-24-_xmod,
	panel_y+(final_height/2)-32,
	7);
}

with (obj_vn_dialogue) {
	draw_dialogue();
}