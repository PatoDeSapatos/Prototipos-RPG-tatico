function camera_zoom(_percent, _is_zoom_in=true,_zoom_rate=.25) {
	with(obj_camera) {
		var _mult = _is_zoom_in ? -1 : 1;
		
		target_zoom_w = RES_W + (RES_W * (_percent/100))*_mult;
		target_zoom_h = RES_H + (RES_H * (_percent/100))*_mult;
		zoom_rate = _zoom_rate;
		obj_camera.state = camera_state_zoom;
	}
}

function camera_zoom_reset(_zoom_rate=.25) {
	with (obj_camera) {
		target_zoom_w = RES_W;
		target_zoom_h = RES_H;
		zoom_rate = _zoom_rate;
		state = camera_state_zoom;
	}
}

function camera_state_zoom() {
	with (obj_camera) {
		camera_w = lerp(camera_w, target_zoom_w, zoom_rate);
		camera_h = lerp(camera_h, target_zoom_h, zoom_rate);
	
		if ((camera_w == target_zoom_w) && (camera_h == target_zoom_h) || (target_zoom_w == -1 || target_zoom_h == -1)) {
			state = noone;
		}
	}
}

function camera_set_bar(_percent, _rate=.2) {
	with (obj_camera) {
		cinematic_bar = camera_w*_percent/100;
		cinematic_bar_rate = _rate;
	}
}

function camera_reset_bar() {
	with (obj_camera) {
		cinematic_bar = 0;
	}
}

function camera_set_x_buffer(_value, _rate) {
	with(obj_camera) {
		x_buffer = _value;
		x_buffer_rate = _rate;
	}
}

function camera_set_y_buffer(_value, _rate) {
	with(obj_camera) {
		y_buffer = _value;
		y_buffer_rate = _rate;
	}
}

function camera_reset_buffer() {
	with(obj_camera) {
		x_buffer = 0;
		y_buffer = 0;
	}
}