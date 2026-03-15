extends Control

const BATTLE_MAIN = preload("res://battle/BattleMain.tscn")
@onready var tab_container: TabContainer = $TabContainer

# Join Menu
@onready var join: MarginContainer = $TabContainer/Join
@onready var text_edit: TextEdit = $TabContainer/Join/VBoxContainer/TextEdit
@onready var join_button: Button = $TabContainer/Join/VBoxContainer/JoinButton

# Lobby Menu
const PLAYER_CARD = preload("res://interfaces/player_card.tscn")
@onready var lobby: MarginContainer = $TabContainer/Lobby
@onready var players_box: VBoxContainer = $TabContainer/Lobby/MarginContainer/VBoxContainer/ScrollContainer/PlayersBox
@onready var start_button: Button = $TabContainer/Lobby/MarginContainer/VBoxContainer/HBoxContainer/StartButton

func _ready() -> void:
	text_edit.text_changed.connect(_on_text_changed)
	join_button.pressed.connect(_on_button_pressed)
	start_button.pressed.connect(_on_start_pressed)
	NetworkHandler.player_connected.connect(_on_player_connected)

func _on_text_changed():
	NetworkHandler.username = text_edit.text

func _on_button_pressed():
	var unit = PartyUnitInfo.create(
		Vector2.ZERO, 
		Stats.create(30, 15, 15), 
		30, 15, 15,
		Inventory.new([
			ItemStack.new(5, Items.get_item("HEALTH_POTION")),
			ItemStack.new(1, Items.get_item("LEMBAS"))
			]), 
		"res://entities/PlayerCharAnimator.tscn", 
		6, 
		[], 
		[], 
		[], 
		null, 
		NetworkHandler.username,
		Stats.new(),
		[],
		1,
		null,
		["rage"]
	)
	
	NetworkHandler.userinfo["unit"] = JSON.stringify(unit.to_dict())
	
	NetworkHandler.register_player.rpc(NetworkHandler.userinfo)
	lobby.show()

func _on_player_connected(player_id, player_info):
	var card = PLAYER_CARD.instantiate()
	players_box.add_child(card)
	card.player_info = player_info

func _on_start_pressed():
	tab_container.hide()
	start_battle.rpc()

@rpc("any_peer", "call_local", "reliable")
func start_battle():
	get_tree().change_scene_to_packed(BATTLE_MAIN)
