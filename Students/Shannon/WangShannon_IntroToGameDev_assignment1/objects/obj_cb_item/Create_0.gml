item_name = "BANDAGE";
item_index = 0;
item_desc = "Heal 15."

unlocked = false;
cost = 0;
healing = 0;
temp_healing = 0;
in_stock = 0;
global.discount = 1; // doctor discount
global.inflation = 1; // chocolatier inflation

function set_items() {
	if (item_index == 0) {
		item_name = "BANDAGE";
		cost = 8;
		healing = 15;
		in_stock = 4;
		item_desc = "Heals " + string(healing) + " HP.";
	}
	if (item_index == 1) {
		item_name = "MEDICAL KIT";
		cost = 20;
		healing = 40;
		in_stock = 2;
		item_desc = "Heals " + string(healing) + " HP.";
	}
	if (item_index == 2) {
		item_name = "PAINKILLER";
		cost = 6;
		temp_healing = 12;
		in_stock = 2;
		item_desc = "Gives " + string(temp_healing) + " temporary HP.";
	}
	if (item_index == 3) {
		item_name = "ADRENALINE";
		cost = 15;
		temp_healing = 35;
		in_stock = 2;
		item_desc = "Gives " + string(temp_healing) + " temporary HP.";
	}
	if (item_index == 4) {
		item_name = "THE HEALING SALVE";
		cost = 60;
		//healing = global.max_player_health - global.player_health;
		in_stock = 1;
		
	}
}