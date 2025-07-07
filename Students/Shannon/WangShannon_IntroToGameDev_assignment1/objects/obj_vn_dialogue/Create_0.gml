txt = "";
fx = [];
xmax = 0;

c_indiv_fx = [set_shake];
c_ct_speed = 0.2;

vfx_color = c_white;
vfx_alpha = 1;
vfx_choice = false;
vfx_choice_immune = false;
vfx_shake = 0;
vfx_indiv = false;
vfx_txtskip = 1;

choice_timer = 0;
choice_val = 1;
choice_lock = false;
choice_ind = -1;

extra_skip = 0;

draw_queue = [];
char_name = {txt: "", fx: []};

/// @description						Parses text into draw_queue to be properly displayed.
/// @param {real} _x					Initial x position.
/// @param {real} _y					Initial y position.
/// @param {string} _txt				Raw text data.
/// @param {array} _fx					List of applied effects.
/// @param {real} _xmax					Text x boundary.
function parse_text(_x, _y, _txt, _fx, _xmax){
	reset_fx();
	draw_set_font(fnt_dp_comic_small);
	
	var _h = 1; var _i = 1; var _j = 0;
	var _e = {x: _x, y: _y, txt: _txt, fx: []};
	var _txttemp = "";
	var _char = "";
	while (_i <= string_length(_e.txt)){
		_char = string_char_at(_e.txt,_i);
		/*check for fx marker*/
		if (_char == "`"){
			//show_debug_message(_e.txt);
			
			_e.txt = string_delete(_e.txt,_i,1);
			_txttemp = string_copy(_e.txt,1,string_length(_e.txt));
			_txttemp = string_delete(_txttemp,_i,string_length(_txttemp)-_i+1);
			array_push(draw_queue,{x: _e.x,y: _e.y,txt: _txttemp, fx: _e.fx});
			
			//show_debug_message(_txttemp);
			
			_e.txt = string_replace(_e.txt,_txttemp,"");
			_e.x += string_width(_txttemp);
			_i = 1;
			
			//show_debug_message(_e.txt);

			if (_j > array_length(_fx)){show_debug_message("ERROR: No fx to correspond with marker"+string(_j)+"!")}
			else{
				_e.fx = _fx[_j];
				if is_array(_e.fx) && array_contains(c_indiv_fx,_e.fx[0]){vfx_indiv = !vfx_indiv;}
			}
			_j++;
		}
		else if vfx_indiv{
			//show_debug_message(_e.txt);
			
			_txttemp = string_copy(_e.txt,1,string_length(_e.txt));
			_txttemp = string_delete(_txttemp,_i+1,string_length(_txttemp)-_i);
			array_push(draw_queue,{x: _e.x,y: _e.y,txt: _txttemp, fx: _e.fx});
			
			//show_debug_message(_txttemp);
			
			_e.txt = string_replace(_e.txt,_txttemp,"");
			_e.x += string_width(_txttemp);
			_i = 1;
			
			//show_debug_message(_e.txt);
		}
		else{
			if (_char == " "){
				_h = _i+1;
			}
			if (_char == "\n"){
				_e.txt = string_delete(_e.txt,_i,1);
				_txttemp = string_copy(_e.txt,1,string_length(_e.txt));
				_txttemp = string_delete(_txttemp,_i,string_length(_txttemp)-_i+1);
				array_push(draw_queue,{x: _e.x,y: _e.y,txt: _txttemp, fx: _e.fx});
				
				_e.txt = string_replace(_e.txt,_txttemp,"");
				_e.x = _x;
				_e.y += string_height("a") * 1.2;
				
				_h = 1;
				_i = 0;
			}
			else if (_e.x + string_width(string_delete(_e.txt,_i,string_length(_e.txt)-_i+1)) > _xmax){
				//show_debug_message(string_delete(_e.txt,_i,string_length(_e.txt)-_i+1));
				_txttemp = string_copy(_e.txt,1,string_length(_e.txt));
				_txttemp = string_delete(_txttemp,_h,string_length(_txttemp)-_h+1);
				array_push(draw_queue,{x: _e.x,y: _e.y,txt: _txttemp, fx: _e.fx});
				//show_debug_message(_txttemp);
				//show_debug_message(_e.txt);

				_e.txt = string_replace(_e.txt,_txttemp,"");
				_e.x = _x;
				_e.y += string_height("a") * 1.2;
				
				//show_debug_message(_e.txt);
				
				_h = 1;
				_i = 0;
			}
			_i++;
		}
	}
	array_push(draw_queue,_e);
	draw_set_font(fnt_dp_comic);
}

function draw_dialogue() {
	draw_set_color(c_white);

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(fnt_dp_comic_small);

	//show_debug_message(draw_queue);
	var _e; var _xmod; var _ymod; var _alph;
	for (var _i = 0; _i < array_length(draw_queue); _i++){
		_e = draw_queue[_i];
	
		if (is_array(_e.fx) && array_length(_e.fx) > 0){
			if (array_length(_e.fx) > 1){script_execute(_e.fx[0],_e.fx[1]);}
			else{script_execute(_e.fx[0]);}
		}
	
		if (vfx_choice && point_in_rectangle(mouse_x,mouse_y,_e.x,_e.y,_e.x+string_width(_e.txt),_e.y+string_height(_e.txt))){
			if (choice_ind == -1){
				choice_ind = _i;
				choice_lock = true;
			}
			choice_timer += c_ct_speed;
			if (choice_timer > 1){choice_timer = 1;}
		}
		else{
			if (choice_ind == _i){
				choice_ind = -1;
				choice_timer = 0;
				choice_lock = false;
			}
		}
	
		_xmod = random_range(-1*vfx_shake,vfx_shake);
		_ymod = random_range(-1*vfx_shake,vfx_shake);
	
		_alph = vfx_alpha;
		if (!vfx_choice_immune && choice_lock && choice_ind != _i){_alph *= 1-0.75*choice_timer;}
		draw_text_color(_e.x+_xmod,_e.y+_ymod,_e.txt,vfx_color,vfx_color,vfx_color,vfx_color,_alph);
	
		//if (extra_skip > 0){draw_text(mouse_x,mouse_y,extra_skip);}
	}

	draw_set_font(fnt_dp_comic);
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
}