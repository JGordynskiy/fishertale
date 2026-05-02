extends Node2D
@onready var pause_menu: Control = $"Pause Menu/CanvasLayer"
@onready var fish = get_node("fish") 
var fanSpeed : float = 30
var fanOn = false
@onready var wallfish: CharacterBody2D = $Wallfish
@onready var fan: Node2D = $fan

@onready var music_loop: AudioStreamPlayer = $Music/musicLoop


@onready var fadeRect = preload("res://scenes/ui/fade_rect.tscn")
@onready var clearpopup = preload("res://scenes/ui/clearpopup.tscn")
@onready var rng = RandomNumberGenerator.new()
@onready var whirlpool = preload("res://scenes/entities/whirlpool.tscn")

#roe popup
@onready var roePopup = preload("res://scenes/objects/roe_popup.tscn")




func _ready() -> void:
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = false
	add_child(thunkfade)
	

	
	globalSignals.game2toR.connect(fadeaway)
	globalSignals.connect("boss2death", boss2clear)
	globalSignals.gameOver.connect(gameOver)
	global.pausable = true
	globalSignals.boss2Start.connect(bossStart)
	
	globalSignals.justPaused.connect(pauseGame)
	globalSignals.justUnPaused.connect(unpauseGame)
	
	#pause_menu.pausable = true
	$"ambience".play()
	pass 
func pauseGame():
	
	$Music/musicInt.bus = "lowpass"
	$Music/musicLoop.bus = "lowpass"
	$Music/musicEnd.bus = "lowpass"
	
func unpauseGame():
	$Music/musicInt.bus = "Music"
	$Music/musicLoop.bus = "Music"
	$Music/musicEnd.bus = "Music"
func gameOver():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(music_loop, "volume_db", -50, 4)
	tween.tween_property(music_loop, "pitch_scale", 0.2, 2)

func boss2clear():
	var tween = get_tree().create_tween()
	tween.tween_property(global, "score", global.score + 10000, 2)
	
	
	$Music/musicInt.stop()
	$Music/musicLoop.stop()
	$Music/musicEnd.play()
	fan.turnOff()
	var instance = clearpopup.instantiate()
	add_child(instance)
	
	#roe popup
	var roeP = roePopup.instantiate()
	roeP.global_position = fish.global_position
	roeP.actualText = "+"+str(12)
	global.roe += 12
	rng.randomize()
	roeP.global_position.x += randf_range(-1000,1000)
	rng.randomize()
	roeP.global_position.y += randf_range(-1000,1000)
	add_child(roeP)
	
	#sapawning portal
	await get_tree().create_timer(2, false).timeout
	var portal = whirlpool.instantiate()
	global.whirlPoolPos = Vector2(9000, 0)
	portal.global_position = global.whirlPoolPos
	add_child(portal)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if (fish.global_position.x < 16000 && fanOn && !fish.mult > 1):
		fish.global_position.x += fanSpeed
	
	if wallfish.boss2hp > 0 && global.hp > 0 && fanOn:
		global.score -= snapped(100*delta, 1)
	
	pass
	
	

func _on_ambience_finished() -> void:
	$"ambience".play()

func fadeHint():
	var org = $tutmouse.modulate.a
	org /= 100
	for i in range(100):
		$tutmouse.modulate.a -= org
		await global.timer(0.05)

func bossStart():
	fadeHint()
	
	await get_tree().create_timer(1, false).timeout
	
	$Music/musicInt.play()
	pass


func _on_music_int_finished() -> void:
	$Music/musicLoop.play()
	pass # Replace with function body.

func fadeaway():
	await get_tree().create_timer(0.5, false).timeout
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = true
	add_child(thunkfade)
	
	
