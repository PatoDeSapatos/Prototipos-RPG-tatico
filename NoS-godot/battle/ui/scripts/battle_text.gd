class_name BattleText extends Control

@onready var panel_container: MarginContainer = $PanelContainer
@onready var label: RichTextLabel = $PanelContainer/MarginContainer/Label
@onready var timer: Timer = $Timer

@onready var initial_position := position

var texts: Array[String]
var step: int = 0

func _ready() -> void:
	visible = false
	_hide()

#func _unhandled_input(event: InputEvent) -> void:
	#if (event.is_action_pressed("menu_confirm")):
		#add_battle_text("Teste " + str(texts.size()))
		#add_battle_text("Biro Biro usou
#[img]res://actions/assets/normal_texture.tres[/img][color=819796] Sword Slash [/color]")

func _hide():
	var target_pos = Vector2(initial_position)
	target_pos.x -= panel_container.size.x
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(self, "position", target_pos, 0.2)

func _show():
	if (!visible):
		visible = true
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(self, "position", initial_position, 0.25)

func _on_timer_timeout() -> void:
	step += 1
	
	if (step >= texts.size()):
		texts.clear()
		step = 0
		
		_hide()
		return
	
	label.text = texts[step]
	timer.start() 

func add_battle_text(text: String):
	texts.push_back(text)
	
	if (timer.is_stopped()):
		label.text = texts[step]
		timer.start()
		_show()
