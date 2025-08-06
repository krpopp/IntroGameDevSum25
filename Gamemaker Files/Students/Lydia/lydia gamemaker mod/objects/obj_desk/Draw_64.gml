if(list_on){
	draw_sprite(spr_list,0,0,0);
	
	if(global.desk_exists){
		draw_sprite(spr_tick,0,277,188);
	}
	
	if(global.mirror_exists){
		draw_sprite(spr_tick,0,282,265);
	}
}