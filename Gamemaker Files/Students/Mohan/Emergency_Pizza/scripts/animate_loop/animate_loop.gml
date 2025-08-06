/// Helper: loops through start_frame…end_frame at `loops_per_sec`
function animate_loop(start_frame, end_frame, loops_per_sec) {
    var count    = end_frame - start_frame + 1;
    var per_step = loops_per_sec * count / room_speed;
    sequence     = (sequence + per_step) mod count;
    image_index  = start_frame + floor(sequence);
}

function array_contains(arr, value) {
    for (var i = 0; i < array_length(arr); i++) {
        if (arr[i] == value) return true;
    }
    return false;
}

global.has_chosen = false;