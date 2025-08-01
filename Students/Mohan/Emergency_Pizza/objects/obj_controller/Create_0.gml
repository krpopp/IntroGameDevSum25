obj_controller.persistent = false
if (!variable_global_exists("collected_items")) {
    global.collected_items = [];
}

global.timer_active = false;
global.time_limit = 120;
global.time_remaining = global.time_limit;
global.temp_value = 100;


global.has_checked_pizza = false;
global.timer_active = false;
global.time_remaining = global.time_limit;

randomize(); 
global.correct_pizza = choose("meat", "vegan");
show_debug_message("Correct pizza: " + string(global.correct_pizza));