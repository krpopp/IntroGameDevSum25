flat = !flat;
if dead{flat = true;}

path_current = path_holter_pulse;
if flat{
	path_current = path_flat;
	if (dead){path_endaction = path_action_continue;}
}

if (path_queue_change != 0){
	path_change_point(path_flat,1,path_queue_change,0,100);
	path_queue_change = 0;
}

path_start(path_current,line_spd,path_action_stop,false);

//pulse = (pulse+1)%c_pulse_max;

//if (pulse%c_pulse_max = c_pulse_max-1){path_endaction = path_action_stop;}
//if (pulse%c_pulse_max = 0){
//	x = reset.x; 
//	path_start(path_holter_pulse,line_spd,path_action_continue,false);
//}