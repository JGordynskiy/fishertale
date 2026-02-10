extends Node2D

@onready var pause_menu: Control = $"Pause Menu/CanvasLayer"
@onready var fadeanimation_player: AnimationPlayer = $faderect/faderect/AnimationPlayer
@onready var fadeRect = load("res://scenes/ui/fade_rect.tscn")
@onready var whirlpool = load("res://scenes/entities/whirlpool.tscn")
@onready var camera: Camera2D = $fish/followCam
@onready var rng = RandomNumberGenerator.new()

#roe popup
@onready var roePopup = load("res://scenes/objects/roe_popup.tscn")
@onready var xtraRoe = 0
@onready var fish = get_node("fish") 
@onready var boss1 = get_node("evilFish") 
@onready var clearpopup = load("res://scenes/ui/clearpopup.tscn")

@onready var boss_1_loop: AudioStreamPlayer = $Music/Boss1loop
@onready var boss_1_end: AudioStreamPlayer = $Music/Boss1end
@onready var boss_1_looplowpass: AudioStreamPlayer = $Music/boss1looplowpass
@onready var boss_1_int: AudioStreamPlayer = $Music/boss1int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	global.stopwatch = 0
	
	camera.tutorial = false
	globalSignals.justPaused.connect(pauseGame)
	globalSignals.justUnPaused.connect(unpauseGame)
	global.pausable = true
	globalSignals.boss1death.connect(spawnPortal)
	globalSignals.gameOver.connect(gameOver)
	globalSignals.game1toR.connect(fadeaway)
	globalSignals.boss1death.connect(bossDeath)
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = false
	add_child(thunkfade)
	
	
	$"ambience".play()
	await get_tree().create_timer(0.25, false).timeout
	boss_1_loop.volume_db = -2
	boss_1_loop.pitch_scale = 1
	boss_1_int.play()
	
	boss_1_looplowpass.volume_db = -79
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if boss1.boss1hp > 0 && global.hp > 0:
		global.stopwatch += delta
	pass

func bossDeath():
	if global.stopwatch < 45:
		xtraRoe = 5
	
func pauseGame():
	boss_1_loop.volume_db = -79
	boss_1_looplowpass.volume_db = -4
	#var tween = create_tween()
	#tween.set_parallel()
	#tween.tween_property(boss_1_loop, "volume_db", -79, 0.5)
	#tween.tween_property(boss_1_looplowpass, "volume_db", -10, 0.2)
	
func unpauseGame():
	boss_1_loop.volume_db = -4
	boss_1_looplowpass.volume_db = -79
	#var tween = create_tween()
	#tween.set_parallel()
	#tween.tween_property(boss_1_loop, "volume_db", -4, 0.5)
	#tween.tween_property(boss_1_looplowpass, "volume_db", -79, 0.2)
	

func gameOver():
	global.pausable = false
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(boss_1_loop, "volume_db", -50, 4)
	tween.tween_property(boss_1_loop, "pitch_scale", 0.2, 2)
	boss_1_looplowpass.stop()
	$"ambience/AnimationPlayer".play("fadeout")
	await get_tree().create_timer(4, false).timeout
	boss_1_loop.stop()
	pass
	
	
	
#MUSIC
#func _on_boss_1_loop_finished() -> void:
	#if boss1.boss1hp > 0 && global.hp > 0:
		#boss_1_loop.play()
		#boss_1_looplowpass.play()
	#pass # Replace with function body.

func spawnPortal():
	#"clear!" text
	var instance = clearpopup.instantiate()
	add_child(instance)
	
	
	#adding ROE
	var roeP = roePopup.instantiate()
	roeP.global_position = fish.global_position
	roeP.actualText = "+"+str(10)
	global.roe += 10
	rng.randomize()
	roeP.global_position.x += randf_range(-1000,1000)
	rng.randomize()
	roeP.global_position.y += randf_range(-1000,1000)
	add_child(roeP)
	
	boss_1_loop.stop()
	boss_1_looplowpass.stop()
	boss_1_end.play()
	
	
	await get_tree().create_timer(2, false).timeout
	var portal = whirlpool.instantiate()
	portal.visible = false
	portal.global_position = Vector2(20000,-8500)
	global.whirlPoolPos = portal.global_position
	add_child(portal)
	
	pass


func _on_boss_1_int_finished() -> void:
	if (boss1.boss1hp > 0):
		boss_1_loop.play()
		boss_1_looplowpass.play()
	pass # Replace with function body.
	
func fadeaway():
	await get_tree().create_timer(0.5, false).timeout
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = true
	add_child(thunkfade)
