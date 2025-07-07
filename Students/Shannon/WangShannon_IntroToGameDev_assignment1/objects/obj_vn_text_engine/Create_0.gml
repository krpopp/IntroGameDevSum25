/*CONSTANTS*/
#macro EMPTY_TEXT_ELEMENT {x: 0, y: 0, char: Character.None, state: "", txt: "", fx: []} /*Empty text element*/
c_text_spd = 3; /*Number of frames to delay next print by.*/
c_punc_spd = 18; /*Number of delay frames to add if glyph is a punctuation mark.*/
c_puncs = [".",",","?","!",";","-"]; /*Punctuation mark list.*/

/*DATA AND VARS*/
dialogue_list = ds_list_create();

dialogue_running = false;
dialogue_index = 0;
dialogue_elem = EMPTY_TEXT_ELEMENT;

text_ptr = 0;
text_delay = 0;
text_line_ready = false;
text_is_choice = false;
text_obj = instance_create_layer(x,y,"UI",obj_vn_dialogue);

char_obj = instance_create_layer(x,y,"Instances",obj_vn_character);

panel_width = 40;  
panel_height = 40;
panel_x = room_width/2;
panel_y = room_height-60;
final_width = 460;
final_height = 120;
panel_state = "closed"; // states: closed, closing, open, opening

def_x = panel_x-(final_width/2)+24; /*Default text init x position*/
def_y = panel_y-(final_height/2)+20; /*Default text init y position*/


/*FUNCTIONS*/
/// @description					Update sequence called at Step.
function update() {
	open_close_animation();
	if dialogue_running{
		grab_current_elem();
		if (panel_state == "open"){
			tick_text();
			advance_dialogue();
		}
	}
	else{
		text_obj.txt = "";
		text_obj.char_name = character_name();
	}
}

/// @description					Adds a text element to dialogue_list.
/// @param {real} _x				Top-left x-pos.
/// @param {real} _y				Top-left y-pos.
/// @param {any} _char				Character speaking.
/// @param {string} _state			Character animation state.
/// @param {string} _txt			Text (with fx markers).
/// @param {array} _fx				(optional) Special effects container.
/// @param {real} _xmax				(optional) Specifies maximum x position.
function add_text_elem(_x, _y, _char, _state, _txt, _fx = [], _xmax = 460){
	ds_list_add(dialogue_list, {x: _x, y: _y, char: _char, state: _state, txt: _txt, fx: _fx, xmax: _xmax});
}

/// @description					Sets the text element to the one indexed by dialogue_index.
function grab_current_elem(){
	if (ds_list_size(dialogue_list) > dialogue_index) {
		dialogue_elem = ds_list_find_value(dialogue_list,dialogue_index);
		
		if (is_struct(dialogue_elem) && variable_instance_exists(dialogue_elem, "char") &&
		variable_instance_exists(dialogue_elem, "state") && variable_instance_exists(dialogue_elem, "fx")) {
			
			char_obj.set_speaker(dialogue_elem.char);
			char_obj.set_state(dialogue_elem.state);
			text_is_choice = false;
			
			for (var _i = 0; _i < array_length(dialogue_elem.fx); _i++){
				if (dialogue_elem.fx[_i][0] == set_choice){text_is_choice = true;}
			}
		}
	}
}

/// @description					Ticks text forward by one frame.
function tick_text(){
	text_delay--;
	
	if (text_delay <= 0){
		text_ptr += text_obj.vfx_txtskip;
		text_obj.vfx_txtskip = 1;
		text_delay = c_text_spd;
		
		if (text_ptr > string_length(dialogue_elem.txt)){
			text_ptr--;
			text_delay = 0;
			text_line_ready = true;
		}
		else if (array_contains(c_puncs,string_char_at(dialogue_elem.txt,text_ptr-1)) && !array_contains(c_puncs,string_char_at(dialogue_elem.txt,text_ptr))){
			text_delay += c_punc_spd;
		}
	}
	
	text_obj.char_name = character_name(dialogue_elem.char);
	text_obj.txt = string_delete(dialogue_elem.txt,-1,-1*(string_length(dialogue_elem.txt)-text_ptr));
	text_obj.x = dialogue_elem.x;
	text_obj.y = dialogue_elem.y;
	text_obj.fx = dialogue_elem.fx;
	text_obj.xmax = variable_instance_exists(dialogue_elem, "xmax") ? dialogue_elem.xmax : 460; 
	//fsr this line kept being weird even though i never entered it as parameter so doing a instance_exists check first
}

/// @description					Flushes out dialogue_list.
function clear_dialogue(){
	ds_list_clear(dialogue_list);
}

/// @description					Runs the contents of dialogue_list.
function run_dialogue(){
	text_ptr = 0;
	text_delay = 0;
	text_line_ready = false;
	dialogue_running = true;
	init_textbox();
}

/// @description					Advances to next dialogue element in dialogue_list.
function advance_dialogue() {
	if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)
		|| keyboard_check_pressed(vk_enter)) {
		if (text_line_ready){
			if !text_is_choice{
				index_skip(1+text_obj.extra_skip);
			}
			else if (text_obj.choice_ind != -1){
				index_skip(text_obj.choice_val);
				text_obj.choice_lock = false;
			}
		}
		else{
			text_ptr = string_length(dialogue_elem.txt);
			text_delay = 0;
		}
		
		if (dialogue_index >= ds_list_size(dialogue_list)){
			dialogue_elem = EMPTY_TEXT_ELEMENT;
			dialogue_running = false;
			panel_state = "closing";
			//clear_dialogue();
		}
	}
}

/// @description					Skips dialogue index by _n.
/// @param {real} _n				(optional) Amount to skip index by
function index_skip(_n = 1){
	dialogue_index += _n;
	text_ptr = 1;
	text_delay = 0;
	text_line_ready = false;
}

function init_textbox() {
	//visible = true;
	panel_state = "opening";
	panel_width = 40;
	panel_height = 40;
}

function open_close_animation() {
	if (panel_state == "opening") {
	    if (abs(panel_height - final_height) > 1) {
	        panel_height = lerp(panel_height, final_height, 0.3);
	    }
	    else if (abs(panel_width - final_width) > 1) {
	        panel_width = lerp(panel_width, final_width, 0.1);
			panel_height = lerp(panel_height, final_height, 0.3);
	    }
	    else {
	        panel_width = final_width;
	        panel_height = final_height;
	        panel_state = "open";
	    }
		
	}

	if (panel_state == "closing") {
		//show_debug_message(panel_width);
	    if (abs(panel_height - 50) > 1) {
	        panel_height = lerp(panel_height, 50, 0.4);
	    }
	    else if (abs(panel_width - 50) > 1) {
	        panel_width = lerp(panel_width, 50, 0.3);
			panel_height = lerp(panel_height, 50, 0.4);
	    }
	    else {
	        panel_width = 50;
	        panel_height = 50;
	        panel_state = "closed";
	    }
	}
}
