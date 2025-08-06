if (global.d_talking ){
draw_sprite(spr_textbox,0,0,0);
draw_set_font(Font1);
draw_set_color(c_white);

if(dialogue_line == 1){
		draw_sprite(spr_dierdre_face,0,75,410);
		draw_text(285, 450,"......");
	
	}
	
	if(dialogue_line == 2){
		draw_sprite(spr_player_face,0,75,410);
		draw_text(285, 450,"......");
	
	}
	
}