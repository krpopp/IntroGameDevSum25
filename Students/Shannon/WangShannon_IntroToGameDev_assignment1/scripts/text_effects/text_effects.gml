/// @description					Set vfx_shake to _args[0].
/// @param {array} _args			[shake]
function set_shake(_args = [0]){
	vfx_shake = _args[0];
}

/// @description					Set vfx_color to args[0].
/// @param {array} _args			[color]
function set_color(_args = [c_white]){
	vfx_color = _args[0];
}

/// @description					Set vfx_alpha to args[0].
/// @param {array} _args			[alpha]
function set_alpha(_args = [1]){
	vfx_alpha = _args[0];
}

/// @description					Shuts off normal dialogue advancement, and turns text into a choice.
/// @param {array} _args			[is choice?, ptr skip amnt]
function set_choice(_args = [false,1]){
	vfx_choice = _args[0];
	if !choice_lock{choice_val = _args[1];}
}

/// @description					Sets text to be immune to choice alpha fading
/// @param {array} _args			[immune?]
function set_choice_immune(_args = [false]){
	vfx_choice_immune = _args[0];
}

/// @description					When dialogue advances, pointer will skip by this amount instead of 1.
/// @param {array} _args			[ptr skip amnt]
function skip_dialogue_pointer(_args = [1]){
	extra_skip = _args[0] - 1;
}

/// @description					Instantly draws text by jumping the pointer forward n characters.
/// @param {array} _args			[ptr jump amnt]
function jump_txt(_args = [1]){
	vfx_txtskip = _args[0];
}

/// @description					Resets all vfx variables.
/// @param {array} _args			[dummy]
function reset_fx(_args = [true]){
	set_color();
	set_shake();
	set_alpha();
	set_choice();
	set_choice_immune();
	//jump_txt();
	//skip_dialogue_pointer();
	vfx_indiv = false;
}

/// @description					Converts a Character enum into their name in format {txt, fx}.
/// @param {any} _char				Character Enum.
function character_name(_char = Character.None){
	var _r = {
		txt: "",
		fx: [[set_choice_immune,[true]],[set_color,[c_white]],[set_color],[set_choice_immune]]
	};
	/* Feel free to replace the fx field with custom effects (eg. different colors) */
	
	switch _char{
		case Character.Bartender: _r.txt = "``Elora, The Bartender``"; break;
		case Character.Chef: _r.txt = "``Randey, The Chef``"; break;
		case Character.Chocolatier: _r.txt = "``Megalo, The Chocolatier``"; break;
		case Character.Doctor: _r.txt = "``Xueqing, The Doll Doctor``"; break;
		case Character.Guardian_Angel: _r.txt = "``Guardian Angel``"; break;
		case Character.Jester: _r.txt = "``The Jester``"; break;
		case Character.Markswoman: _r.txt = "``Yuexia, The Markswoman``"; break;
		case Character.Mathematician: _r.txt = "``Vicente, The Mathematician``"; break;
	}
	return _r;
}