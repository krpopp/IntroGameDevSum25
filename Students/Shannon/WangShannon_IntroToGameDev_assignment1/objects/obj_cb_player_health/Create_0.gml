global.player_health_max = 120;

global.player_health = global.player_health_max;

health_ratio = 1.00;


function update() {
	update_health_ratio();
}

function update_health_ratio() {
	health_ratio = global.player_health / global.player_health_max;
}