
if (is_hovered) {
    target_x = original_x + 40; 
}
else {
    target_x = original_x; 
}


x = lerp(x, target_x, 0.2);

if (is_dragging) {
	original_x = x;
    x = mouse_x - sprite_width/2;
    y = mouse_y - sprite_height/2;
}
