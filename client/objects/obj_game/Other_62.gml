global.loading = true;
request_function = -1;

struct_foreach(global.requests, function (key, value) {
	if (ds_map_find_value(async_load, "id") == value[0]) {
		request_function = value[1];
	}
});

if (ds_map_find_value(async_load, "status") == 0) {
	if (request_function != -1) script_execute(request_function);
}
global.loading = false;