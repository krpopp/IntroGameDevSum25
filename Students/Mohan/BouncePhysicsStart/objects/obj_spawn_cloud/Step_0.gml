cloud_timer += 1;

var cloud_count = instance_number(obj_cloud);

if (cloud_timer > frames_between_clouds || cloud_count < min_clouds) {
    if (cloud_count < max_clouds) {
        var spawn_x = random_range(30, room_width - 30);
        var spawn_y = random_range(50, room_height - 150);

        var new_cloud = instance_create_layer(spawn_x, spawn_y, "Instances", obj_cloud);

        with (new_cloud) {
            var attempts = 0;
            while (
                attempts < 3000 &&
                collision_rectangle(x - 24, y - 24, x + 24, y + 24, obj_cloud, false, true) != noone
            ) {
                x = random_range(30, room_width - 30);
                y = random_range(50, room_height - 100);
                attempts++;
            }
        }

        cloud_timer = 0;
    }
}
