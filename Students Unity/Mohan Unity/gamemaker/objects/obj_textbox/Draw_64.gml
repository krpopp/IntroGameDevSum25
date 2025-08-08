var npc_x = npc_instance.x;
var npc_y = npc_instance.y;

var cam_x = camera_get_view_x(view_camera[0]);
var cam_y = camera_get_view_y(view_camera[0]);
var view_width = camera_get_view_width(view_camera[0]);
var view_height = camera_get_view_height(view_camera[0]);

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

var scale_x = gui_width / view_width;
var scale_y = gui_height / view_height;

var gui_x = (npc_x - cam_x) * scale_x;
var gui_y = (npc_y - cam_y) * scale_y;

var box_x = gui_x - (box_width / 2);
var npc_height = sprite_get_height(npc_instance.sprite_index);
var box_y = gui_y - npc_height - 80;

box_x = clamp(box_x, 10, gui_width - box_width - 10);
box_y = clamp(box_y, 10, gui_height - box_height - 10);

draw_set_color(c_black);
draw_rectangle(box_x, box_y, box_x + box_width, box_y + box_height, false);

draw_set_color(c_white);
draw_rectangle(box_x + 5, box_y + 5, box_x + box_width - 5, box_y + box_height - 5, true);
draw_rectangle(box_x + 6, box_y + 6, box_x + box_width - 6, box_y + box_height - 6, true);

draw_set_font(fnt_text);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text_ext(box_x + padding + 5, box_y + padding, txt, -1, box_width - (padding * 2) - 10);
