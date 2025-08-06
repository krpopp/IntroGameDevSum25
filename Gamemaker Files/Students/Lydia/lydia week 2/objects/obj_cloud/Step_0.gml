if (state != "stepped") {
    cloud_stage_timer++;
}


switch (state) {

    
    case "idle":
        if (cloud_stage < 5) {
            var duration = stage_durations[cloud_stage - 1];
            if (cloud_stage_timer >= duration) {
               
                state = "growing";
                cloud_stage_timer = 0;

              
                var start_frame = stage_anim_frames[(cloud_stage - 1) * 2];
                image_index = start_frame;
                image_speed = animation_speed;
            }
        }
        break;

  
    case "growing":
        var end_frame = stage_anim_frames[(cloud_stage - 1) * 2 + 1];

        if (image_index >= end_frame) {
            
            image_index = end_frame;
            image_speed = 0;

            
            cloud_stage++;
            cloud_stage_timer = 0;
            state = "idle";
        }
        break;
		
	case "stepped":
	if( cloud_stage >= 2){
		var die_frame = destroy_anim_frames[(cloud_stage - 2) * 2 + 1];
		image_speed = animation_speed; 

		if (floor(image_index) >= die_frame){
			instance_destroy();
		}
	}
	break; 
}

