if (instance_exists(obj_player)) {
    var currentSpeed = obj_player.current_speed;
    var baseSpeed = obj_player.base_speed;
    var maxSpeed = obj_player.max_speed;

    var sprintProgress = clamp((currentSpeed - baseSpeed) / (maxSpeed - baseSpeed), 0, 1);

    var totalFrames = 4;
    image_index = floor(sprintProgress * (totalFrames - 1));
}
