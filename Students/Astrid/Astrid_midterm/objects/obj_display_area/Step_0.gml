//if (is_active) {
   
//    text_alpha = min(text_alpha + fade_speed, 1.0);
//} else {
  
//    text_alpha = max(text_alpha - fade_speed, 0.0);
//}


//for an ease in and ease out while hovering
if (is_active == true) {
    target_alpha = 1.0;
} else {
    target_alpha = 0.0;
}

//more smooth ease in or ease out
text_alpha = lerp(text_alpha, target_alpha, fade_speed);

//if opacity close to 0, update new next
if (!is_active && text_alpha < 0.01) {
    current_text = "";
} 

//if hover on new card, update new text 
else if (is_active) {
    current_text = display_text;
}
