draw_self();

if (instance_exists(obj_player)) {
    if (distance_to_object(obj_player) < interaction_range) {
        draw_set_font(fnt_click); // or use your pixel font
        draw_set_halign(fa_center); // center horizontally
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        draw_set_alpha(1); // fully opaque, avoid blur

        draw_text(x + 30, y - 20, "Click me!");

        draw_set_halign(fa_left);  // reset alignment (optional)
        draw_set_valign(fa_top);
    }
}
