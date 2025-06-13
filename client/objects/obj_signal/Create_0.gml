instances = []

function connect(_name, _listener, _instance) {
	array_push(instances, {
		name: _name,
		listener: _listener,
		instance: _instance
	})
}

function send(_name) {
	array_filter_ext(instances, function(e) {
		return instance_exists(e.instance)
	})
	
	for (var i = 0; i < array_length(instances); ++i) {
	    if (instances[i].name == _name) {
			instances[i].listener()	
		}
	}
}