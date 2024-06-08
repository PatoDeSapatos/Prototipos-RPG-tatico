function set_transition(_in_transition, _out_transition, _callback = -1, _transition_rate = 0.03, _await_min_duration = 0 ) {
	with (obj_camera) {
		out_transition = _out_transition;
		transition_rate = _transition_rate;
		await_min_duration = _await_min_duration;
		transition_callback = _callback;
		
		transition = _in_transition;
	}
}

function stop_transition() {
	obj_camera.to_stop_transition = true;
}

function end_transition_in() {
	if (transition_progress >= 1) {
		if (transition_callback != -1) {
			script_execute(transition_callback);
			transition_callback = -1;
		}
		
		transition = transition_await;
		transition_progress = 0;
		return true;	
	} else {
		transition_progress += transition_rate;	
		return false;
	}
}

function end_transition_out() {
	if ( transition_progress >= 1 ) {
		transition = -1;
		transition_progress = 0;
		global.pause = false;
		return true;
	} else {
		transition_progress += transition_rate;
		return false;	
	}	
}

function set_camera_default() {
	with (obj_camera) {
		cinematic_bar = false;
		inside_room_camera = true;
		global.can_zoom = false;
		follow = noone;
		camera_w = RES_W;
		camera_h = RES_H;
		camera_x = 0;
		camera_y = 0;
	}
}

function transition_circle_in() {
	var _w = RES_W*global.res_scale;
	var _h = RES_H*global.res_scale;
	
	if ( !surface_exists( transition_surface ) ) {
		transition_surface = surface_create( _w, _h );	
	}
	
	surface_set_target( transition_surface );
	
	draw_set_color(c_black);
	draw_rectangle(0, 0, _w, _h, false);
	draw_set_color(c_white);
	
	gpu_set_blendmode(bm_subtract);
	draw_circle(_w/2, _h/2, (_w/1.5)*(1-transition_progress), false);
	gpu_set_blendmode(bm_normal);
	
	surface_reset_target();
	draw_surface(transition_surface, 0, 0);
	
	return end_transition_in();
}

function transition_circle_out() {
	var _w = RES_W*global.res_scale;
	var _h = RES_H*global.res_scale;
	
	if ( !surface_exists( transition_surface ) ) {
		transition_surface = surface_create( _w, _h );	
	}
	
	surface_set_target( transition_surface );
	
	draw_set_color(c_black);
	draw_rectangle(0, 0, _w, _h, false);
	draw_set_color(c_white);
	
	gpu_set_blendmode(bm_subtract);
	draw_circle(_w/2, _h/2, (_w/1.5)*(transition_progress), false);
	gpu_set_blendmode(bm_normal);
	
	
	surface_reset_target();
	draw_surface(transition_surface, 0, 0);
	
	return end_transition_out();
}

function transition_fade_in() {
	var _w = RES_W*global.res_scale;
	var _h = RES_H*global.res_scale;
	
	draw_set_alpha(transition_progress);
	draw_set_color(c_black);
	
	draw_rectangle(0, 0, _w, _h, false);
	
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	return end_transition_in();
}

function transition_fade_out() {
	var _w = RES_W*global.res_scale;
	var _h = RES_H*global.res_scale;	
	
	draw_set_alpha(1 - transition_progress);
	draw_set_color(c_black);
	
	draw_rectangle(0, 0, _w, _h, false);
	
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	return end_transition_out();
}

function transition_await() {
	var _w = RES_W*global.res_scale;
	var _h = RES_H*global.res_scale;
	
	draw_set_color(c_black);
	draw_rectangle(0, 0, _w, _h, false);
	draw_set_color(c_white);
	
	transition_progress += 1/FRAME_RATE;
	if( to_stop_transition && transition_progress >= await_min_duration ) {
		transition = out_transition;
		transition_progress = 0;
		out_transition = -1;
	}
	
	return true;
}