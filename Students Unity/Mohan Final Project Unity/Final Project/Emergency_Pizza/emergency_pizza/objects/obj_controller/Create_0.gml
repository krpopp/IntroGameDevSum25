// Turn off texture filtering for pixel clarity
if (!surface_exists(application_surface)) {
    gpu_set_texfilter(false);
}

// Initialize global variables safely
if (!variable_global_exists("collected_items")) {
    global.collected_items = [];
}

global.timer_active = false;
global.time_limit = 120;
global.time_remaining = global.time_limit;
global.temp_value = 100;

// Randomly choose the correct pizza type
global.correct_pizza = choose("meat", "vegan");

// Set flag to avoid duplicate result checks
global.has_checked_pizza = false;
