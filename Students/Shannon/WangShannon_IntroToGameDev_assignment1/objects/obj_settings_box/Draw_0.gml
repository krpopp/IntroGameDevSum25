var _center_x = room_width / 2;
var _center_y = room_height / 2;

var _clamped_width = panel_width;
var _clamped_height = panel_height;

if (panel_state == "opening" || panel_state == "closing") {
    _clamped_width = max(panel_width, 40);
    _clamped_height = max(panel_height, 40);
}

draw_sprite_stretched(spr_box, 0, _center_x - _clamped_width / 2, _center_y - _clamped_height / 2, 
_clamped_width, _clamped_height);

/*draw_set_color(c_white);
draw_text(50, 50, panel_state);*/

/*
if (visible) {
    draw_sprite(spr_guardian_angel_arms, 0, 0, 0);
}*/

