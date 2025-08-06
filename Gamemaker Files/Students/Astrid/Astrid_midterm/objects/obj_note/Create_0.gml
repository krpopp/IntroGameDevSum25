width = 100;
height = 100;

text = "";

original_x = 0;
original_y = 0;

target_x = 0;
target_y = 0;
hover_offset = 0;
is_in_slot = false;
original_depth = -1000;

scale = 1;

//limit the hover area
mask_index = sprite_index;
was_hovered = false; 
is_hovered = false;

content_id = -1;     
is_dragging = false;

should_hover = false;

global.is_placed = false;