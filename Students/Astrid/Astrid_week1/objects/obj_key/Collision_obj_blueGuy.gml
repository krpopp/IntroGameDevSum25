//if collide with obj...

//the global.inventory is written in obj_door Creat Event
global.inventory += 1;

instance_deactivate_object(obj_key);

audio_play_sound(snd_key,0,false);