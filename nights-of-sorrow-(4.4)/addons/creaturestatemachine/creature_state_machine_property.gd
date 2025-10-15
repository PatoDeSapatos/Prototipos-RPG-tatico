extends EditorProperty

var button: Button
signal pressed()

func _init() -> void:
	button = Button.new()
	button.text = "Edit State Machine"
	button.pressed.connect(_on_button_pressed)
	add_child(button)
	
func _on_button_pressed():
	pressed.emit()
