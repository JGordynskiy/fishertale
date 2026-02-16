extends Control

@export var paused = false
#var pausable = false
@onready var fadeRect = load("res://scenes/ui/fade_rect.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game  = get_owner()
@onready var mousePos


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	globalSignals.actuallyTakeDmg.connect(dmgPause)
	animation_player.speed_scale = 2
	paused = false
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if global.pausable:
		if Input.is_action_just_pressed("pause"):
			if paused == false: 
				pause()
			else: 
				unpause()
	pass
	

func dmgPause():
	pass
	#var pauseTime : float
	#if global.hp > 1:
		#pauseTime = 0.15
	#else:
		#pauseTime = 0.4
	#pausable = false
	#get_tree().paused = true
	#await get_tree().create_timer(pauseTime).timeout
	#get_tree().paused = false
	#pausable = true

func pause():
	
	mousePos = get_viewport().get_mouse_position()
	
	$"../areyousure".visible = false
	global.pausable = false
	globalSignals.emit_signal("justPaused")
	$"pause".play()
	modulate.a = 0
	visible = true
	animation_player.play("pause")
	paused = true
	get_tree().paused = true
	await get_tree().create_timer(0.2).timeout
	global.pausable = true
	
func unpause():
	
	Input.warp_mouse(mousePos)
	$"../areyousure".visible = false
	global.pausable = false
	globalSignals.emit_signal("justUnPaused")
	$"unpause".play()
	modulate.a= 250
	animation_player.play("unpause")
	paused = false
	get_tree().paused = false
	await get_tree().create_timer(0.2).timeout
	visible = false
	global.pausable = true


func _on_quit_pressed() -> void:
	$"../areyousure".visible = true
	$".".visible = false
	$select.play()
	pass # Replace with function body.


func _on_really_quit_pressed() -> void:
	$select.play()
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = true
	add_child(thunkfade)
	
	global.curBoss = 0
	
	global.pausable = false
	
	await get_tree().create_timer(1).timeout
	
	
	get_tree().paused = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/levels/main_menu.tscn")
	
	pass # Replace with function body.


func _on_nvm_pressed() -> void:
	$".".visible = true
	$"../areyousure".visible = false
	$select.play()
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	if global.pausable:
		unpause()
	pass # Replace with function body.
