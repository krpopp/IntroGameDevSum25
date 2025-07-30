key_left   = keyboard_check(ord("A"));
key_right  = keyboard_check(ord("D"));
key_up     = keyboard_check(ord("W"));
key_down   = keyboard_check(ord("S"));
key_sprint = keyboard_check(vk_shift);

if (key_sprint) {
    sprint_timer += 1 / room_speed;
    var level = floor(sprint_timer);
    current_speed = base_speed + (max_speed - base_speed) * min(level / 4, 1);
} else {
    sprint_timer = 0;
    current_speed = base_speed;
}

var move_horizontal = key_right - key_left;
var move_vertical   = key_down  - key_up;

hsp = move_horizontal * current_speed;
vsp = move_vertical   * current_speed;

if (place_meeting(x + hsp, y, obj_collide)) {
    while (!place_meeting(x + sign(hsp), y, obj_collide)) {
        x += sign(hsp);
    }
    hsp = 0;
}
x += hsp;

if (place_meeting(x, y + vsp, obj_collide)) {
    while (!place_meeting(x, y + sign(vsp), obj_collide)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;

var loops_per_sec_idle = 1;
var loops_per_sec_move = 1.5;
var loop_rate = (hsp == 0 && vsp == 0) ? loops_per_sec_idle : loops_per_sec_move;

if (hsp == 0 && vsp == 0) {
    switch (facing) {
        case "right":      animate_loop(anim_right[0], anim_right[1], loop_rate); break;
        case "left":       animate_loop(anim_left[0], anim_left[1], loop_rate); break;
        case "up":
        case "up_left":
        case "up_right":   animate_loop(anim_up[0], anim_up[1], loop_rate); break;
        default:           animate_loop(anim_down[0], anim_down[1], loop_rate); break;
    }
} else {
    if (vsp < 0) {
        if (key_right && !key_left) {
            facing = "up_right";
            animate_loop(22, 25, loop_rate);
        } else if (key_left && !key_right) {
            facing = "up_left";
            animate_loop(18, 21, loop_rate);
        } else {
            facing = "up";
            animate_loop(anim_up[2], anim_up[3], loop_rate);
        }
    } else if (vsp > 0) {
        if (key_right && !key_left) {
            facing = "down_right";
            animate_loop(anim_right[2], anim_right[3], loop_rate);
        } else if (key_left && !key_right) {
            facing = "down_left";
            animate_loop(anim_left[2], anim_left[3], loop_rate);
        } else {
            facing = "down";
            animate_loop(anim_down[2], anim_down[3], loop_rate);
        }
    } else if (hsp > 0) {
        facing = "right";
        animate_loop(anim_right[2], anim_right[3], loop_rate);
    } else if (hsp < 0) {
        facing = "left";
        animate_loop(anim_left[2], anim_left[3], loop_rate);
    }
}

if (!can_move) {
    hsp = 0;
    vsp = 0;
    exit;
}


x = clamp(x, 0, room_width  - sprite_width);
y = clamp(y, 0, room_height - sprite_height);