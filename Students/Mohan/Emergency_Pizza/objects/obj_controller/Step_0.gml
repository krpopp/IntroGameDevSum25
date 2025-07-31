// ✅ Start timer only when player collects a pizza
if (!global.timer_active) {
    for (var i = 0; i < array_length(global.collected_items); i++) {
        var item = global.collected_items[i];
        if (item == obj_pizza_meat || item == obj_pizza_vegan) {
            global.timer_active = true;
            break;
        }
    }
}

// ✅ Timer countdown logic
if (global.timer_active) {
    global.time_remaining -= 1 / room_speed;

    if (global.time_remaining <= 0) {
        global.time_remaining = 0;
        global.timer_active = false;
        room_restart(); // or room_goto(rm_fail);
    }
}

// ✅ Result check logic (once)
if (!global.has_checked_pizza) {
    var has_meat = instance_exists(obj_pizza_meat);
    var has_vegan = instance_exists(obj_pizza_vegan);
    var has_gift = object_exists(obj_hidden_gift) && instance_exists(obj_hidden_gift);

    if (has_gift) {
        room_goto(rm_special);
        global.has_checked_pizza = true;
    }
    else if (global.correct_pizza == "meat" && has_meat && !has_vegan) {
        room_goto(rm_ending);
        global.has_checked_pizza = true;
    }
    else if (global.correct_pizza == "vegan" && has_vegan && !has_meat) {
        room_goto(rm_ending);
        global.has_checked_pizza = true;
    }
    else if (has_meat || has_vegan) {
        room_goto(rm_fail);
        global.has_checked_pizza = true;
    }
}
