x = 86;
y = 90;
image_xscale = 0.7;
image_yscale = 0.7;
depth = obj_cb_signature_flower.depth + 50;

/*Monitor std particle effect*/
ps = part_system_create();
part_system_global_space(ps, true);
part_system_draw_order(ps, true);

//part_holter_tail
//Emitter
ptype1 = part_type_create();
part_type_shape(ptype1, pt_shape_disk);
part_type_size(ptype1, 1, 1, 0, 0);
part_type_scale(ptype1, 0.025, 0.025);
part_type_speed(ptype1, 0, 0, 0, 0);
part_type_direction(ptype1, 180, 180, 0, 0);
part_type_gravity(ptype1, 0, 180);
part_type_orientation(ptype1, 0, 0, 0, 0, false);
part_type_colour3(ptype1, $B0CCA3, $426632, $324C26);
part_type_alpha3(ptype1, 0.71, 0.651, 0);
part_type_blend(ptype1, false);
part_type_life(ptype1, 120, 120);


pemit1 = part_emitter_create(ps);
part_emitter_region(ps, pemit1, 0, 0, 0, 0, ps_shape_rectangle, ps_distr_linear);
part_emitter_stream(ps, pemit1, ptype1, 1);

part_system_position(ps, room_width/2, room_height/2);
part_system_layer(ps, "Holter");


/*Flat pulse path*/
path_flat = path_add();
path_set_closed(path_flat,false);
path_add_point(path_flat,0,0,100);
path_add_point(path_flat,40,0,100);

/*Variables*/
reset = {x: self.x, y: self.y};
pulse = 75;
line_spd = 1;
flat = false;
dead = false;
path_current = path_holter_pulse;
path_queue_change = 0;

/*Constants*/
c_monitor_width = 100;
c_pthresh_min = 0.14;
c_pthresh_max = 0.94;

debug = false;

function set_pulse(_n){
	pulse = _n; dead = false;
	if (pulse == 0){dead = true; path_queue_change = 40;}
	else{path_queue_change = 45*(60/_n);}
}

path_rescale(path_holter_pulse,1,1);
path_start(path_holter_pulse,line_spd,path_action_stop,false);