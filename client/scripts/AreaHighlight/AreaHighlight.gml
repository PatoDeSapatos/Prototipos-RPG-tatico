function Area(_origin_x, _origin_y, _callback, _comparative, _shape=noone) constructor {
	origin_x = _origin_x
	origin_y = _origin_y
	callback = _callback
	comparative = _comparative
	shape = _shape
	
	is_in_area = function(_x, _y) {
		return callback(_x, _y, origin_x, origin_y, comparative, shape)
	}
}