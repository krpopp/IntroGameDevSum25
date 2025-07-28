draw_set_font(Font1);
draw_set_color(text_color);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

//var center_x = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) / 2;
//var center_y = camera_get_view_y(view_camera[0]) + 200;


    //draw_text(center_x, center_y, page_texts[current_page]);


var center_x = display_get_gui_width() / 2;
var start_y = 400;                
var max_width = 1000;              
var line_spacing = 20;           
var content = page_texts[current_page];

	
draw_set_alpha(fade_alpha);


   draw_text_ext(center_x, start_y, content, 35, max_width);

draw_set_alpha(1); 