class_name InventoryList extends PanelContainer


@onready var options_container: VBoxContainer = $ElementOptions/OptionsContainer
@onready var selector: TextureRect = $Selector
var current_option := 0
var elements: Array[Node]
var focus := false

signal option_changed(new_option: int)
signal option_interacted(option: InventoryOption)

func _ready() -> void:
	option_changed.connect(_on_option_changed)

func _process(delta: float) -> void:
	if (len(elements) <= 0):
		return
	
	var dir = int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"))
	
	if (dir != 0):
		var new_option = get_option_in_bounds(current_option + dir)
		option_changed.emit(new_option)
	
	if (Input.is_action_just_pressed("menu_confirm") || Input.is_action_just_pressed("mouse_left")):
		option_interacted.emit(elements[current_option])

func get_option_in_bounds(option: int) -> int:
	var new_option = option
	
	if (new_option >= len(elements)):
		new_option = 0
	elif (new_option < 0):
		new_option = len(elements)-1
	
	return new_option

func change_option_selected(option: int):
	option = get_option_in_bounds(option)
	option_changed.emit(option)

func add_element(element: InventoryOption):
	element.focused.connect(_on_option_focus)
	elements.push_back(element)
	options_container.add_child(element)
	
func clear() -> void:
	for e in options_container.get_children():
		e.queue_free()
	
	elements.clear()

func _on_option_focus(option: InventoryOption):
	var new_option = options_container.get_children().find(option)
	
	if (new_option != -1 && new_option != current_option):
		option_changed.emit(new_option)

func _on_option_changed(new_option: int):
	# inventory option
	var option : InventoryOption = elements[new_option]
	elements[current_option].change_selection(false)
	option.change_selection(true)
	
	var selector_pos = option.global_position
	selector_pos.x -= selector.size.x
	selector_pos.y += (option.size.y - selector.size.y)/2
	
	selector.set_pos(selector_pos)
	current_option = new_option
