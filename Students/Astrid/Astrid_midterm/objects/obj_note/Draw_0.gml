//if(abs(x - target_x) > 1) {
//	x = lerp(x, target_x, 0.1);
//} else {
//	x = target_x;
//}

//if(abs(y - target_y) > 1) {
//	y = lerp(y, target_y, 0.1);
//} else {
//	y = target_y;
//}
//draw_self();

//draw_set_color(c_yellow);


//draw_sprite_stretched(spr_note_1, 0, x, y,150,150);
//draw_set_color(c_black);
//draw_text_ext(x+10, y+10, text, 15, width-20);


var draw_offset = (depth * -1) * 4;

draw_sprite_ext(sprite_index, image_index, 
               x, y, 
               scale, scale, 0, c_white, 1);

draw_set_color(c_black);
//draw_text_ext(x + 40, y + 40, 
//              text, 20, sprite_width - 20);