if (!surface_exists(application_surface)) {
    gpu_set_texfilter(false);
}


// Only run if not already initialized (for room reload safety)
if (!variable_global_exists("collected_items")) {
    global.collected_items = [];
}
global.timer_active = false;
global.time_limit = 120;
global.time_remaining = global.time_limit;
global.temp_value = 100;