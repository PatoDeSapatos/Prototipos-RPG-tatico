/// @description
timer++;

curr_x = lerp(curr_x, target_x, rate);
if (abs(curr_x - target_x) <= rate) {
	curr_x = target_x;	
	if (vanish) {
		if (page >= array_length(texts)-1) {
			instance_destroy();	
		}
		target_x = start_x - text_width[page] - padding;
		vanish = false;
	}
} else {
	timer = 0;	
}

if (!vanish) {
	target_x = start_x - text_width[page] - padding;
}	

if (timer >= waiting_time) {
	timer = 0;	

	if (page >= array_length(texts)-1) {
		vanish = true;
		target_x = gui_w + text_width[page] + padding*2;
		page = array_length(texts)-1;
	} else {
		page++;
	}
}