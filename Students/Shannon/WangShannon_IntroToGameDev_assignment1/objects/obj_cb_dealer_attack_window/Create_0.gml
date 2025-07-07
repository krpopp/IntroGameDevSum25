
global.dealer_attacking = false;

// revolvor
revolver_timer = 0;

// sniper
sniper_timer = 0;

// tommygun
tommygun_timer = 0;



function dealer_revolver_attack() {
	revolver_timer = 150;
	global.dealer_attacking = true;
}

function dealer_sniper_attack() {
	sniper_timer = 150;
	global.dealer_attacking = true;
}

function dealer_tommygun_attack() {
	tommygun_timer = 0;
	global.dealer_attacking = true;
}

function update() {
	check_if_attacking();
}

function check_if_attacking() {
	if (revolver_timer > 0) {
		
	}
	else if (sniper_timer > 0) {
	}
	else if (tommygun_timer > 0) {
	}
	else {
		global.dealer_attacking = false;
	}
}