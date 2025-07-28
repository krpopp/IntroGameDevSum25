note_contents = [
"April 2014: Jane got a love confession. From Luan, her childhood friend, her closest confidant. But Jane said no. I can see the panic in Jane's eyes, and her hands trembling. Jane said Luan was not well, and she's scared that Luan will hurt herself.",
"April 2014, late night: I couldn't sleep! What if Luan was hurting herself? I had to check. But when I peeked inside... Luan was gripping a packet charm, her words sharp as glass: < Jane I hate you! >",
"April 2014: Jane was smiling when she got back today. She said Luan acted so normal today like she never even confessed. But I confused. Last night... the hatred in Luan's voice... just didn't add up.",
"September 2018: Jane's boyfriend, Jason was gone. Jane collapsed. She applied a year off from university, locked herself in her apartment, and refused to see anyone.",
"September 2018: Every single day, Luan arrived at Jane's place, witha can of my favorite food in hand. Luan nearly did everything to get Jane to move on, she wanted Jane to reconnect with the world. Did I misjudged Luan? Maybe Luan is a good person.", 
"September 2018: Human logic is absurd. Jane told Luan she wanted to bring me to vet and get me a lethargic, this SUNDAY. Girl, after months of isolation, jsut say you a date with fresh air, don't take me as an excuse!", 
"December 2018: Something was wrong with Jane. The vet visit changed her. I heard Luan's voice cut through the street calling her name, yet Jane walked on, oblivious, as if Luan's screaming at air or Jane just suddenly became deaf.", 
"December 2018: One second, Jane was walking. The next, she just... stopped, at the middle of the road. Luan's screams clawed at the air < JANE, GET OUT OF THE ROAD!!! > like a warning Jane couldn't hear.",
"December 2018: Red light. A truck's horn roared. I clawed at Jane's skin, drawing blood. I'm screeming from inside < JANE, please! Move!!! > But she just stood there, a statue in the kill zone.", 
"December 2018: In the last moment before I lost conscious, I remember only: Jane suddenly snapped back to herself *her eyes clearing, widening* just as Luan lunged toward us." 
];

note_sprites = [
    spr_note_1, spr_note_2, spr_note_3, 
    spr_note_4, spr_note_5, spr_note_6,
    spr_note_7, spr_note_8, spr_note_9,
    spr_note_10
];

var stack_x = 50;  
var stack_y = 50;
var stack_offset = 60;

for (var i = 0; i < 10; i++) {
    var note = instance_create_layer(stack_x, stack_y + i*stack_offset, "Instances", obj_note);
    note.content_id = i;
    note.text = note_contents[i];
	
    note.sprite_index = note_sprites[i];  //give different sprites
    note.image_index = 0; 
    note.original_x = stack_x;
    note.original_y = stack_y+ i*stack_offset;
    note.target_x = stack_x;
    note.target_y = stack_y;
    note.depth = -i;
	note.note_id = i;
	
}

global.current_hover_note = noone; 

display_area = instance_create_layer(0, 0, "HUD", obj_display_area);
display_area.is_active = false; 

slot_id = 0;
expected_content_id = 0; 

