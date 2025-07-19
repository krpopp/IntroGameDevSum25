if (cloud_state != "stepped") {
    growth_timer++;
}

switch (cloud_state) {
    case "normal":
        if (growth_level <= 4) {
            var wait_time = growth_durations[growth_level - 1];
            if (growth_timer >= wait_time) {
                cloud_state = "growing";
                growth_timer = 0;
                var frame_start = growth_frames[(growth_level - 1) * 2];
                image_index = frame_start;
                image_speed = frame_speed;
            }
        }
        break;
        
    case "growing":
        var frame_end = growth_frames[(growth_level - 1) * 2 + 1];
        if (image_index >= frame_end) {
            image_index = frame_end;
            image_speed = 0;
            growth_level++;
            growth_timer = 0;
            cloud_state = "idle";  
        }
        break;
        
    case "idle":  
        cloud_state = "normal";  
        break;
        
    case "stepped":
        if (growth_level >= 2) {
            var destroy_start = destroy_frames[(growth_level - 2) * 2];
            var destroy_end = destroy_frames[(growth_level - 2) * 2 + 1];
            if (image_index < destroy_start) {
                image_index = destroy_start;
                image_speed = frame_speed;
            }
            if (floor(image_index) >= destroy_end) {
                instance_destroy();
            }
        } else {
            instance_destroy();
        }
        break;
}