extends Control

@export var paused = false
#var pausable = false


@onready var animation_player: AnimationPlayer = $AnimationPlayer


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
