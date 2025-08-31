class_name SplashScreen extends Control

@export var load_scene: PackedScene = load("res://main.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $CenterContainer/VBoxContainer/TextureRect
var time: int
var amp: float = 5
var spd: float = 1.8

func _ready() -> void:
	animation_player.play("fade")

func _process(delta: float) -> void:
	time += 1
	texture_rect.position.y = sin(time * delta * spd) * amp
	if (Input.is_action_just_pressed("menu_confirm")):
		animation_player.stop()
		on_end()

func on_end():
	get_tree().change_scene_to_packed(load_scene)
