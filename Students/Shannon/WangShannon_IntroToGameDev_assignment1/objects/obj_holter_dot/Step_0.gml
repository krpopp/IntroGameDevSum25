if (!global.menu_pause) {
	part_system_position(ps, x, y);
	//part_system_position(ps2, x, y);

	if (path_current == path_holter_pulse && path_position >= c_pthresh_min && path_position <= c_pthresh_max){
		var _x = path_get_x(path_holter_pulse,c_pthresh_min)-path_get_x(path_holter_pulse,path_position);
		var _y = path_get_y(path_holter_pulse,c_pthresh_min)-path_get_y(path_holter_pulse,path_position);
	
		//if (x+_x < reset.x){_x = reset.x;}
	
		part_particles_burst(ps,_x,_y,part_holter_pulse);
	}

	if (x >= reset.x + c_monitor_width){
		var _pos = path_position;
		path_end();
		x = reset.x - path_get_x(path_current,_pos);
		y = reset.y;
		path_start(path_current,line_spd,path_action_stop,false);
		path_position = _pos;
		
	}
	
	if (global.dealer_defeated_bloodshed) {
		part_particles_clear(ps);
		path_end();
	}
	
	/*
	if keyboard_check(ord("Q")){
		debug = true;
	}
	else{
		debug = false;
	}

	if keyboard_check(vk_up){set_pulse(pulse+10);}
	if keyboard_check(vk_down){set_pulse(pulse-10);}
	if keyboard_check(ord("W")){set_pulse(0);}
	if keyboard_check(ord("E")){set_pulse(75);}*/
	
}