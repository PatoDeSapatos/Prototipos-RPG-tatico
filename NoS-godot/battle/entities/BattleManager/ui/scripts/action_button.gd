extends Button

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var key_text: Label = $Key/KeyText

@export var trigger_input: StringName = &"attack_action"
@export var angle: int

func _ready() -> void:
	key_text.text = InputMap.action_get_events(trigger_input)[0].as_text().split()[0]
	pass

func set_hdir(dir : String):
	animation_player.play(dir)

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed(trigger_input)):
		# TODO implement menu change
		print(trigger_input)
