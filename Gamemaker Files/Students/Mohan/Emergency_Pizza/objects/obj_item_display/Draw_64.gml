draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_main);

var x_pos = 16;
var y_pos = 16;

draw_text(x_pos, y_pos, "🎒 Items:");
y_pos += 24;

if (variable_global_exists("collected_items")) {
    for (var i = 0; i < array_length(global.collected_items); i++) {
        var item_name = global.collected_items[i];
        draw_text(x_pos + 16, y_pos, string(i + 1) + ". " + item_name);
        y_pos += 20;
    }
}
