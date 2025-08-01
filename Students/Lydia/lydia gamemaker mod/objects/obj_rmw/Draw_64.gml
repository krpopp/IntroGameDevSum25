if (global.rmw_talking == true){
draw_sprite(spr_textbox,0,0,0);
draw_set_font(Font1);
draw_set_color(c_white);
	
if(dialogue_line == 1){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"Hello, old friend.");
	
}

if(dialogue_line == 2){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"or should I say");
}

if(dialogue_line == 3){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"new friend.");
}

if(dialogue_line == 4){
	draw_sprite(spr_player_face,0,75,410);
	draw_text(285, 450,"......");
}

if(dialogue_line == 5){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"Relax.");
}

if(dialogue_line == 6){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"Old or new, we are friends. ");
}

if(dialogue_line == 7){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"Friends help each other. ");
}

if(dialogue_line == 8){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"I've got something for you. You'll find it when  ");
	draw_text(285, 470,"you start another day.  ");
}

if(dialogue_line == 9){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"You've got so much to do. ");
}

if(dialogue_line == 11){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"Do you like it? ");
}

if(dialogue_line == 12){
	draw_sprite(spr_player_face,0,75,410);
	draw_text(285, 450,"...... ");
}

if(dialogue_line == 13){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"It might seems like a short list but ");
}

if(dialogue_line == 14){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"trust me it gets longer.  ");
}

if(dialogue_line == 15){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"By finishing tasks on the list you get [ticks],");
}

if(dialogue_line == 16){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"and you can exchange things with me using ");
	draw_text(285, 470,"[ticks].  ");
}

if(dialogue_line == 17){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"For example. If you can give me five [ticks],");
}

if(dialogue_line == 18){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"I can in exchange give you this [page arrow].");
}

if(dialogue_line == 19){
	draw_sprite(spr_player_face,0,75,410);
	draw_text(285, 450,"......");
}

if(dialogue_line == 20){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"I can see you looking forward to it. ");
}

if(dialogue_line == 21){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"You'll learn how to finish the tasks,");
}

if(dialogue_line == 22){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"but I'll give you a little help as you're ");
	draw_text(285, 470,"just starting.");
}

if(dialogue_line == 23){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"On the other side of the house you'll find ");
	draw_text(285, 470,"a girl,");
}

if(dialogue_line == 24){
	draw_sprite(spr_rmw_face,0,75,410);
	draw_text(285, 450,"helping her is helping yourself. ");
}
	
}