global.weapon_in_use = false;
global.weapon_instance = noone;

global.revolver_in_use = false;
global.sniper_in_use = false;
global.tommygun_in_use = false;

with (obj_revolver_weapon) {
	instance_destroy();
}


function spawn_revolver() {
	with (obj_revolver_weapon) {
		instance_destroy();
	}
	global.weapon_in_use = true;
	global.revolver_in_use = true;
	var _rev = instance_create_layer(400, 500, "Weapons", obj_revolver_weapon);
	global.weapon_instance = _rev;
	_rev.rev_state = "spawn";
	_rev.visible = true;
}

function update() {
	//show_debug_message(string(global.weapon_in_use) + string(global.card_interactable) + string(global.played_card));
}