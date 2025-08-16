if (!has_been_checked && instance_exists(obj_player)) {
    var dist = point_distance(x, y, obj_player.x, obj_player.y);

    if (dist < interaction_range) {
        // Convert world position to GUI position (if needed)
        var gui_x = camera_get_view_x(view_camera[0]);
        var gui_y = camera_get_view_y(view_camera[0]);

        var screen_x = x - gui_x;
        var screen_y = y - gui_y;

        draw_set_font(fnt_click); // Replace with your font
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_text(screen_x, screen_y - 40, "Click me?");
    }
}
