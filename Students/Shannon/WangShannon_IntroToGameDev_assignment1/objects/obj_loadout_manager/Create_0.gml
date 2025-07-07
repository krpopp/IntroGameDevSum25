
global.items_unlocked = ds_list_create();
global.items_shop = ds_list_create();
ds_list_add(global.items_unlocked, "Bandage");
ds_list_add(global.items_unlocked, "Medkit");
ds_list_add(global.items_unlocked, "Painkiller");
/*
ds_list_add(global.items_unlocked, "Adrenaline");
ds_list_add(global.items_unlocked, "Healing Salve");
ds_list_add(global.items_unlocked, "Relic");*/

function set_shop() {
	ds_list_clear(global.items_shop);
	for (var _i = 0; _i < ds_list_size(global.items_unlocked); _i++) {
		var _item = instance_create_layer(x, y, "Items", obj_cb_item);
		_item.unlocked = true;
		_item.item_index = _i;
		_item.set_items();
		ds_list_add(global.items_shop, _item);
	}
	for (var _i = ds_list_size(global.items_unlocked); _i < 5; _i++) {
		ds_list_add(global.items_shop, noone);
	}
}

set_shop();

global.guaranteed_cards = ds_list_create();

global.wheel_of_fortune_cards = ds_list_create();

global.equippable_cards = ds_list_create();

global.attack_cards = ds_list_create();
