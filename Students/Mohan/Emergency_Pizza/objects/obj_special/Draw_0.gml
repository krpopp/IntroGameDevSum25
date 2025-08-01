draw_set_font(fnt_title);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(room_width / 2, title_y, "You are the chosen one!");

if (show_menu) {
    draw_set_font(fnt_menu);

    var text_height = string_height("A"); 
    var line_spacing = text_height + 10;  

    var base_y = title_y + 100;
    var x_center = room_width / 2;

    for (var i = 0; i < array_length(options); i++) {
        var text_y = base_y + i * line_spacing;

        // Draw arrow on the left
        if (i == selected_index) {
            draw_set_halign(fa_right);
            draw_text(x_center - 200, text_y, ">");
        }

        // Draw option text
        draw_set_halign(fa_center);
        draw_text(x_center, text_y, options[i]);
    }
}
