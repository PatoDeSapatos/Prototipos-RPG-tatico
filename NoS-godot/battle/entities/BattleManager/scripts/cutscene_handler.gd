class_name CutsceneHandler extends Resource

const ACTION_EFFECTS = preload("res://actions/ActionEffects.tscn")
var manager: BattleManager
var timer := 0.0
var animation := ""
var setup := false
var loop_mode = 0
var animation_finished := false

var buffer = []

func _init(manager: BattleManager) -> void:
	self.manager = manager

func action_end():
	manager.action += 1
	timer = 0
	animation = ""
	setup = false
	loop_mode = 0
	animation_finished = false
	buffer = []
	
	if (manager.action >= manager.cutscene.size()):
		manager.cutscene = []
		manager.action = 0

func _on_animation_finished():
	animation_finished = true

func action_start(targets):
	if (targets is BattleUnit):
		targets.animating = true
		return
	
	if (targets is Array[BattleUnit]):
		for target in targets:
			target.animating = true

func wait(time: float):
	timer += Engine.get_main_loop().root.get_process_delta_time()
	
	if (timer >= time):
		action_end()

func play_animation(target: BattleUnit, animation_name: String):
	var animations = target.animator.animations
	
	if (animations == null || !animations.has_animation(animation_name)):
		action_end()
		return
	
	if (!setup):
		var target_animation = animations.get_animation(animation_name)
		animation = animations.current_animation
		loop_mode = target_animation.loop_mode
		
		animations.animation_finished.connect(_on_animation_finished)
		animations.play(animation_name)
		animations.advance(0)
		target_animation.loop_mode = Animation.LOOP_NONE
		
		setup = true
	
	if (setup && !animations.is_playing()):
		animations.get_animation(animation_name).loop_mode = loop_mode
		animations.play(animation)
		animations.animation_finished.disconnect(_on_animation_finished)
		action_end()

func play_multiple_animations(targets: Array[BattleUnit], animation_name: String):
	if (targets.size() <= 0):
		action_end()
		return
	
	if (!setup):
		var reference_target: BattleUnit = null
		var valid_targets = []
		var previous_animations = []
		var animation_modes = []
		
		buffer.push_back([])
		buffer.push_back([])
		buffer.push_back([])
		buffer.push_back([])
		
		for target in targets:
			var animations = target.animator.animations
			if (animations.has_animation(animation_name)):
				buffer[0].push_back(target)
				buffer[1].push_back(animations.get_animation(animation_name).loop_mode)
				buffer[2].push_back(animations.current_animation)
				
				animations.play(animation_name)
				reference_target = target

		if (reference_target == null):
			action_end()
			return
		
		reference_target.animator.animations.animation_finished.connect(_on_animation_finished)
		buffer[3] = reference_target.animator.animations
		setup = true
	
	if (setup and !buffer[3].is_playing()):
		for i in buffer[0].size():
			var target: BattleUnit = buffer[0][i]
			var animations = target.animator.animations
			
			animations.get_animation(animation_name).loop_mode = buffer[1][i]
			animations.play(buffer[2][i])
		
		buffer[3].animation_finished.disconnect(_on_animation_finished)
		action_end()

func cast_action_func(action: Action, user: BattleUnit, targets: Array, area: ActionArea):
	var custom_script: ActionCallable = load(action.script_path)
	if (custom_script != null):
		custom_script._call(user, targets, area, action)
		action_end()
		return
	
	var damage = BattleHandler.calc_action_default_damage(action, user)
	for target: BattleUnit in targets:
		BattleHandler.unit_take_damage(damage, user, target, action)
		if (action.target_effect != "" and action.target_effect != null):
			var effect = ACTION_EFFECTS.instantiate()
			effect.z_index = target.z_index + 1
			BattleHandler.add_child(effect)
			effect.play(action.target_effect, target.get_effect_origin_position())
		
	action_end()

func cast_projectile(texture: Texture2D, pos: Vector2, particle_path: String):
	if (!setup):
		buffer.push_back(Projectile.new(pos, texture))
		buffer[0].end.connect(_on_animation_finished)
		buffer[0].particle_path = particle_path
		buffer[0].z_index = 1000
		BattleHandler.add_child(buffer[0])
		setup = true
	
	if (animation_finished):
		buffer[0].end.disconnect(_on_animation_finished)
		action_end()
	
func create_battle_effect(effect_name: String, pos: Vector2, z_index, wait := false, scale := Vector2.ONE):
	if (!setup):
		var effect = BattleHandler.create_battle_effect(effect_name, pos, z_index)
		effect.animation_finished.connect(_on_animation_finished)
		effect.scale = scale
		buffer.push_back(effect)
		setup = true
	
	if (wait):
		if (animation_finished):
			buffer[0].animation_finished.disconnect(_on_animation_finished)
			action_end()
	else:
		buffer[0].animation_finished.disconnect(_on_animation_finished)
		action_end()

func change_stats(target, stat_name, amount):
	BattleHandler.change_unit_stats(target, stat_name, amount)
	action_end()

func instantiate_scene(path: String, global_pos: Vector2, parameters: Dictionary = {}, parent: Node2D = BattleHandler):
	var scene = load(path)
	if (scene != null):
		scene = scene.instantiate()
		scene.global_position = global_pos
		for key in parameters.keys():
			scene[key] = parameters[key]
			
		parent.add_child(scene)
	
	action_end()

func clear_effect_by_name(name: String):
	for item in BattleHandler.get_children():
		if (item is ActionEffects && item.animation_name == name):
			item.queue_free()
	
	action_end()
