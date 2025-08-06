if (global.bwm_talking == true){
draw_sprite(spr_textbox,0,0,0);
draw_set_font(Font1);
draw_set_color(c_white);
	
	if(dialogue_line = 1){
		draw_sprite(spr_bwm_face_smile,0,75,410);
		draw_text(285, 450,"You're here!");
	
	}
	
	if(dialogue_line = 2){
		draw_sprite(spr_bwm_face_smile,0,75,410);
		draw_text(285, 450,"I've been waiting to see you!");
	
	}
	
	if(dialogue_line = 3){
		draw_sprite(spr_bwm_face_smile,0,75,410);
		draw_text(285, 450,"I'm so desperately waiting for you to show up!");
	
	}
	
	if(dialogue_line = 4){
		draw_sprite(spr_bwm_face_smile,0,75,410);
		draw_text(285, 450,"Please help me out!");
	
	}
	
	if(dialogue_line = 5){
		draw_sprite(spr_bwm_face_smile,0,75,410);
		draw_text(285, 450,"......");
	
	}
	
	if(dialogue_line = 6){
		draw_sprite(spr_bwm_face_no_smile,0,75,410);
		draw_text(285, 450,"Is that what you expect me to say?");
	
	}
	
	if(dialogue_line = 7){
		draw_sprite(spr_player_face,0,75,410);
		draw_text(285, 450,"......");
	
	}
	
	if(dialogue_line = 8){
		draw_sprite(spr_bwm_face_no_smile,0,75,410);
		draw_text(285, 450,"......");
	
	}
	
	if(dialogue_line = 9){
		draw_sprite(spr_bwm_face_no_smile,0,75,410);
		draw_text(285, 450,"You haven't changed a bit.");
	
	}
	
	if(dialogue_line = 10){
		draw_sprite(spr_bwm_face_no_smile,0,75,410);
		draw_text(285, 450,"......");
	
	}
	
	if(dialogue_line = 11){
		draw_sprite(spr_bwm_face_no_smile,0,75,410);
		draw_text(285, 450,"But guess what.");
	
	}
	
	if(dialogue_line = 12){
		draw_sprite(spr_bwm_face_smile,0,75,410);
		draw_text(285, 450,"Today is your lucky day.");
	
	}
	
	if(dialogue_line = 13){
		draw_sprite(spr_bwm_face_no_smile,0,75,410);
		draw_text(285, 450,"...just like every other day. ");
	
	}
	
	if(dialogue_line = 14){
		draw_sprite(spr_bwm_face_smile,0,75,410);
		draw_text(285, 450,"Would you do me a favor and get that little pair");
		draw_text(285, 470,"of glasses for me?");
	
	}
	
	if(dialogue_line = 15){
		draw_sprite(spr_bwm_face_smile,0,75,410);
		draw_text(285, 450,"Not everyone has a walking animation like you. ");
		
	
	}

}