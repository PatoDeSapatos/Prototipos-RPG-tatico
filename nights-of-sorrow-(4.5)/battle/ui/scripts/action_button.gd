class_name ActionButton extends Button

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var key_text: Label = $Key/KeyText

@export var trigger_input: StringName = &"attack_action"
@export var state_name: String = ""
@export var angle: int

var active: bool = true:
	set(value):
		active = value
		disabled = !value

signal interacted(button: ActionButton)

func _ready() -> void:
	key_text.text = InputMap.action_get_events(trigger_input)[0].as_text().split()[0]

func set_hdir(dir : String):
	animation_player.play(dir)

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed(trigger_input)):
		interacted.emit(self)
		
func _on_toggled(toggled_on: bool) -> void:
	interacted.emit(self)
