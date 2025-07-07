draw_self();

if debug{
	draw_line(reset.x,reset.y-80,reset.x,reset.y+80);
	draw_line(reset.x+c_monitor_width,reset.y-80,reset.x+c_monitor_width,reset.y+80);
	draw_line(reset.x,reset.y,reset.x+c_monitor_width,reset.y);
	draw_text(reset.x,reset.y+100,"Pulse: "+string(pulse));
}