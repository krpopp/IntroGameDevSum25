//if (keyboard_check(ord("W")))y = y - 4;}
//if (keyboard_check(ord("S"))){y = y + 4;}
//if (keyboard_check(ord("D"))){x = x + 4;}
//if (keyboard_check(ord("A"))){x = x - 4;}


//move with WASD
var _hor = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _ver = keyboard_check(ord("S")) - keyboard_check(ord("W"));

//move and collide with....
move_and_collide(_hor*move_spd, _ver*move_spd,[obj_wall1,obj_npc1,obj_npc2]);

//limit the moving area (only inside room)
x= clamp(x,20,room_width-20);
y= clamp(y,20,room_height-20);


//add sprites while moveing
//if obj is moving....
if (_hor != 0 or _ver != 0)
{ 
	if (_hor > 0){sprite_index = spr_right_walk;}
	else if (_hor < 0){sprite_index = spr_left_walk;}
	else if (_ver > 0){sprite_index = spr_front_walk;}
	else if (_ver < 0){sprite_index = spr_back_walk;}
}
else //if obj is not moving...
{
	if (sprite_index == spr_right_walk){ sprite_index = spr_right_idle;}
	else if (sprite_index == spr_left_walk){ sprite_index = spr_left_idle;}
	else if (sprite_index == spr_front_walk){ sprite_index = spr_front_idle;}
	else if (sprite_index == spr_back_walk){ sprite_index = spr_back_idle;}
}




//Adding dialoguge

//check if npc1 is near by (collide) 
//have to add 20 since I manually change the anchor in sprite
var npc1_is_here = instance_place(x+20, y+20, obj_npc1) || 
instance_place(x-20, y+20, obj_npc1)||
instance_place(x+20, y-20, obj_npc1)||
instance_place(x-20, y-20, obj_npc1);

var npc2_is_here = instance_place(x+20, y+20, obj_npc2) || 
instance_place(x-20, y+20, obj_npc2)||
instance_place(x+20, y-20, obj_npc2)||
instance_place(x-20, y-20, obj_npc2);


//if collide with npc1
if (npc1_is_here){
	if (keyboard_check_pressed(vk_space)){
		
		if(chatbox_visible == false) {
			global.currently_talking = true;
			audio_play_sound(snd_talk,0,false);
       //obj_textbox.x = x;
       //obj_textbox.y = y;
	        chatbox_visible = true;
	   
	   if(global.inventory == 0){
	global.current_text = global.text1;
	}
	
	if(global.inventory == 1 ){
	global.current_text = global.text2;
	}
}
  }
}

//for npc2
else if (npc2_is_here){
//if there is no npc2 around
	if (keyboard_check_pressed(vk_space)){
		if(chatbox_visible == false) {
					audio_play_sound(snd_talk,0,false);
		global.currently_talking = true;
	global.current_text = global.text3;
	 obj_textbox.x = x;
       obj_textbox.y = y;
	        chatbox_visible = true;
	}
	}} else if (keyboard_check_pressed(vk_space)) {chatbox_visible = false;}


//if out of certain distance, chatbox disappear
else if(-40 < (distance_between_npc2_x)< 40|| -40 < (distance_between_npc2_y) < 40 || 
(-40 < (distance_between_npc1_x)< 40|| -40 < (distance_between_npc1_y) < 40)) 
{
	global.currently_talking = false;
	 chatbox_visible = false;
	
}

