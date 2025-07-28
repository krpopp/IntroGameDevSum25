var btn_text = "Check";
var text_x = x + 23;
var text_y = y + 30;

draw_set_color(c_black);
draw_set_font(Font1);
draw_sprite_ext(sprite_index, image_index, 
               x, y, 
               1, 1, 0, c_white, 1);
draw_text(text_x, text_y, btn_text);

if (is_pressed) {
    draw_set_alpha(0.5);
} else { draw_set_alpha(1);}

