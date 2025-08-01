hsp = 0;
vsp = 0;
base_speed      = 2;
max_speed       = 6;
current_speed   = base_speed;
sprint_timer    = 0;
facing          = "down";
sequence        = 0;        

anim_right      = [0,  1,  2,  5];    // idle[0–1], move[2–5]
anim_left       = [6,  7,  8, 11];    // idle[6–7], move[8–11]
anim_up         = [12, 13, 14, 17];   // idle[12–13], move[14–17]
anim_down       = [26, 27, 28, 31];   // idle[26–27], move[28–31]

image_index     = 26;
can_move = true;
global.has_gift = false;
global.has_speedup = false;