//for chatbox
global.current_text = "";
global.currently_talking = false;

textbox_width = 800;
textbox_height = sprite_height;

//position
x = (display_get_gui_width() - 1150);
y = (display_get_gui_height() - 900);

visible = false;

//text
text_font = Font1;
text_color = c_white;
text_x = 20;
text_y = 10;
text_width = textbox_width - 150; //how wide the text can type within th