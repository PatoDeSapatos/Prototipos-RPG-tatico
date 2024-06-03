request_function = -1;

array_foreach(requests, function(_request) {
	if ( _request.id == async_load[? "id"])	{
		request_function = _request.reaction;
	}
});

if ( async_load[? "status"] == 0 && request_function != -1 ) {
	script_execute(request_function);
}