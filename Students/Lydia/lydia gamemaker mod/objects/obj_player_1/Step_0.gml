
var move = false; 

if(keyboard_check_pressed(vk_down)){
	dir = 1;
}

if(keyboard_check_pressed(vk_up)){
	dir = 2;
}

if(keyboard_check_pressed(vk_left)){
	dir = 3;
}

if(keyboard_check_pressed(vk_right)){
	dir = 4;
}

if(keyboard_check(vk_down)){
	
	if(image_index<5 || image_index  >9 ){
	image_index = 5;
	}
	
	move = true; 
}


if(keyboard_check(vk_up)){
	
	if(image_index<14){
	image_index = 14;
	}
	
	if(image_index>18){
	image_index = 14;
	}
	
	
	move = true; 
	
}

if(keyboard_check(vk_right)){
	
	if(image_index<36){
	image_index = 36;
	}
	
	if(image_index>40){
	image_index = 36;
	}
	
	move = true; 
}


if(keyboard_check(vk_left)){
	
	if(image_index<24){
	image_index = 24;
	}
	
	if(image_index>28){
	image_index = 24;
	}
	move = true; 
	
}

if (move == false){
	if(dir == 1){
		if(image_index < 0 || image_index >5){
			image_index = 0; 
		}
	}
	
	if(dir == 2){
		if(image_index < 9  || image_index > 14){
			image_index = 9; 
		}
	}
	
	if(dir == 3){
		if(image_index < 20|| image_index >24){
			image_index = 20; 
		}
	}
	
	if(dir == 4){
		if(image_index < 31|| image_index >35){
			image_index = 31; 
		}
	}
}


