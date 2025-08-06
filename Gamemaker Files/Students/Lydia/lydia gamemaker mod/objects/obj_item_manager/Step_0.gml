if(room == Room1){
	if(global.list_exists && !global.desk_created){
		instance_create_layer(498,-15,"Instances_1", obj_desk);
		global.desk_created = true; 
	}
	
	if(global.mirror_exists&& !global.mirror_created){
		instance_create_layer(722,194,"Instances_1", obj_mirror);
		global.mirror_created = true; 
		
	}
}