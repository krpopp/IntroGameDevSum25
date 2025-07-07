global.scene_queue = [];
event = noone;

if (room == cutscene_bartender_death) {
}
else if (room == visual_novel_opening) {
	global.scene_queue = [scene_oath_of_the_sins, scene_guardian_angel_prayer, scene_guardian_angel_prayer2, 
	mathematician_doctor_waltz];
}
global.current_scene_index = 0;

transition_timer = 0;
scene_active = false;
cutscene = noone;
global.is_cutscene = false;

function load_scene(_scene_func) {
	with (obj_vn_text_engine) {
	    clear_dialogue();
	    _scene_func();
	    run_dialogue();
	}
	if (event != noone) {
		activate_event(event);
		event = noone;
	}
}

function activate_event(_event) {
	if (_event == "bartender death") {
		obj_bartender_death.slitting_throat = true;
	}
}

function next_scene() {
	if (global.current_scene_index < array_length(global.scene_queue)) {
		scene_active = true;
		var _next = global.scene_queue[global.current_scene_index];
		global.current_scene_index++;
		obj_vn_text_engine.dialogue_index = 0;
		load_scene(_next);
		
	}
}

function update() {
    if (scene_active) {
        if (instance_exists(obj_vn_text_engine) && !obj_vn_text_engine.dialogue_running) {
            scene_active = false;
			if (instance_exists(cutscene)) {
				cutscene.fade_state = "out";
				obj_vn_test_script.cutscene = noone;
				global.is_cutscene = false;
			}
            transition_timer = 140; 
        }
    } else {
        transition();
    }
}

function transition() {
    if (transition_timer <= 0) {
        next_scene();
    } else {
        transition_timer--;
    }
}

function bartender_death() {
	with (obj_vn_text_engine) {
		add_text_elem(def_x, def_y, Character.Bartender,"idle", "...");
	}
}

function bartender_death2() {
	with (obj_vn_text_engine) {
		add_text_elem(def_x, def_y, Character.Bartender,"idle", "Ah... haha... hahahaha...");
		add_text_elem(def_x, def_y, Character.Bartender,"idle", "This... doesn't hurt much more than it already did.");
		
	}
	event = "bartender death";
}


function scene_guardian_angel_prayer() { // cutscene --> VN scene test
	with (obj_vn_text_engine) {
		obj_vn_test_script.cutscene = obj_guardian_angel_praying;
		obj_guardian_angel_praying.fade_state = "in";
		add_text_elem(def_x, def_y, Character.None,"idle","* He's mumbling something. You can't decipher the words.");
		add_text_elem(def_x, def_y, Character.None,"idle","* He doesn't seem to notice you. `\nI. `Grab his attention.` \nII. `Patiently wait besides him.``",
			[[jump_txt,[25]],
			[set_choice,[true,1]],[set_choice],
			[set_choice,[true,2]],[set_choice],
			[jump_txt]]);
		add_text_elem(def_x, def_y, Character.None,"idle","You tap the praying Guardian Angel gently on his shoulder.",[[skip_dialogue_pointer,[2]]]);
		add_text_elem(def_x, def_y, Character.None,"idle","...");
	}
}

function scene_guardian_angel_prayer2() {
	with (obj_vn_text_engine) {
		add_text_elem(def_x, def_y, Character.None,"idle","...");
		add_text_elem(def_x, def_y, Character.Guardian_Angel,"meek","... Sage, you appear before me... in one piece...");
		add_text_elem(def_x, def_y, Character.Guardian_Angel,"idle","My prayer seems to have worked. Our Lord has protected your soul from that sacrilegious card game.");
	}
}

function mathematician_doctor_waltz() {
	with (obj_vn_text_engine) {
		obj_vn_test_script.cutscene = obj_mathematician_doctor_waltz;
		obj_mathematician_doctor_waltz.fade_state = "in";
		global.is_cutscene = true;
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","Interesting, isn't it? We may be Dealers, but we're all still players in a different kind of game.");
		add_text_elem(def_x, def_y, Character.Doctor,"idle","Elaborate.");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","Influence. Control. Even here, no one sits at this table as equals.");
		add_text_elem(def_x, def_y, Character.Doctor,"idle","So where do you place yourself, then?");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","Somewhere comfortably above the rest. But I suspect you believe the same of yourself.");
		add_text_elem(def_x, def_y, Character.Doctor,"idle","Confidence is necessary for those who wish to succeed.");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","Then let's see which of us has calculated their influence more effectively, yes?");
	}
}

function scene_oath_of_the_sins() {
	with (obj_vn_text_engine) {
	
		/* test script - Memory 4, Oath of the Sins */
		add_text_elem(def_x, def_y, Character.Chocolatier,"idle","`Now, it is that time of the year where we all renew our oaths.", [[skip_dialogue_pointer,[1]]]);
		add_text_elem(def_x, def_y, Character.Chocolatier,"idle","Let us go in the order of when we first made our oaths. Starting with you, Vicente.");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","Yes, very well.");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","The numbers never lie. Probability always bends towards those who make it so. I shall remain where I must.");
		add_text_elem(def_x, def_y, Character.Bartender,"idle","Well, what's the point of not renewing my oath? Everything will remain as it is no matter what I do.");
		add_text_elem(def_x, def_y, Character.Jester,"idle","As the Face of the Dealers, I might as well stay where I am.");
		add_text_elem(def_x, def_y, Character.Chocolatier,"idle","Ha, nice joke, Jester! As the most charming of the Dealers, I intend to remain holding our image together.");
		add_text_elem(def_x, def_y, Character.Chef,"idle","A full table, a full stomach, a full life. What more could anyone want?");
		add_text_elem(def_x, def_y, Character.Doctor,"idle","The strong do not apologize for their nature. I have never been ashamed of what I am, and I never will be.");
		add_text_elem(def_x, def_y, Character.Markswoman,"idle","...I must remain where I am.");
		add_text_elem(def_x, def_y, Character.Chocolatier,"idle","Great! Another year to come with my six eccentric colleagues. Cheers!");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","Hold on. Before we drink, I would like everyone's attention. To address the elephant in the room.");
		add_text_elem(def_x, def_y, Character.Chocolatier,"idle","Oh, what is it this time?");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","To put it bluntly, I am the only Dealer here who the game correctly recruited.");
		add_text_elem(def_x, def_y, Character.Chocolatier,"idle","Pssht, what a bold claim! You always put yourself on such a pedestal.");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","Do you remember why we are here?");
		add_text_elem(def_x, def_y, Character.Markswoman,"idle","Yes, that is to protect the Relics from the wrong hands.");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","And how many of you guys took on the Dealer position solely for that?");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","Randey - you took the role so you could stuff your face without consequences.");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","Megalo - you took it to run from the wreckage you left behind in the real world.");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","Elora - you became a Dealer against your own will.");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","Yuexia - you don't even know why you took it. You just... followed.");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","And don't even get me started on you, Xueqing. You took the role for power and control. Your pride demands it.");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","I took this role because I fear for humanity. Because I am capable of bearing that responsibility.");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","But you all? You all make being a Dealer a joke.");
		add_text_elem(def_x, def_y, Character.Mathematician,"idle","And yet, without a second thought, you all just renewed that oath like it means nothing.");
		add_text_elem(def_x, def_y, Character.Doctor,"idle","And yet here we all are. Still standing, while your precious competence leaves you bitter and alone.");
		add_text_elem(def_x, def_y, Character.Chef,"idle","He's not wrong though. I mean you must be stupid to turn down a role that lets you eat all day.");
	}
}