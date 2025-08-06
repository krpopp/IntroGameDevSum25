draw_self();

if (instance_exists(obj_player)) {
    if (distance_to_object(obj_player) < interaction_range) {
        draw_set_font(fnt_click); 
        draw_set_halign(fa_center); 
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        draw_set_alpha(1); 

        draw_text(x + 30, y - 20, "Click me!");

        draw_set_halign(fa_left); 
        draw_set_valign(fa_top);
    }
}
