////this is an event that draw things that are above all instance 
////[maybe imagine in another dimension :P

if (global.currently_talking == true)
{
	//var x1 = 0;
	//var x2 = 1500;
	//var y1 = 900;
	//var y2 = 1200;
	
	//draw_rectangle(x1,y1,x2,y2,false);
	
	draw_sprite(spr_textbox,0,x,y);
	
	//draw text aligned to the left and to the top
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(text_font);
	draw_set_color(text_color);
	draw_text(x+10, y, global.current_text);
} 