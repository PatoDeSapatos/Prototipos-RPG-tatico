extends PanelContainer

@onready var player_name: Label = $PlayerBox/HSplitContainer/PlayerName
@onready var class_label: Label = $PlayerBox/HSplitContainer/HBoxContainer/ClassLabel
@onready var ready_label: Label = $PlayerBox/HSplitContainer/HBoxContainer/ReadyLabel

var player_info: Dictionary:
	set(value):
		player_name.text = value.username
		player_info = value
