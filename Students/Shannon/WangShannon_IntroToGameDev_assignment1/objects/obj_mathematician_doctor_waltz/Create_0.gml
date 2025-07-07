visible = true;
image_speed = 1;
image_alpha = 0;
x = room_width/2;
y = 120;

fade_state = "out";

function fade() {
	if (fade_state == "in") {
		if (image_alpha < 1) {
			image_alpha = clamp(image_alpha + 0.01, 0, 1);
		}
	}
	else {
		if (image_alpha > 0) {
			image_alpha = clamp(image_alpha - 0.01, 0, 1);
		}
	}
}