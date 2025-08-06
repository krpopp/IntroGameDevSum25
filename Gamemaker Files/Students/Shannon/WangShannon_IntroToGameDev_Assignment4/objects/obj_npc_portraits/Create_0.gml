visible = true;

x = 170;
y = room_height - 60;

breathe_timer = 0; 
breathe_speed = 0.04;
breathe_amp = 2.5;

function update() {
	breathe();
}

function breathe() {
	breathe_timer += breathe_speed;
	breathe_offset = sin(breathe_timer) * breathe_amp;
	
	if (breathe_timer > 2 * pi) {
		breathe_timer -= 2 * pi;
	}
}