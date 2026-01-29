extends Node2D
@onready var pause_menu: Control = $"Pause Menu/CanvasLayer"
@onready var fish = get_node("fish") 
var fanSpeed : float = 30
var fanOn = false
@onready var wallfish: CharacterBody2D = $Wallfish
@onready var fan: Node2D = $fan

@onready var fadeRect = load("res://scenes/ui/fade_rect.tscn")
@onready var clearpopup = load("res://scenes/ui/clearpopup.tscn")
@onready var rng = RandomNumberGenerator.new()
@onready var whirlpool = load("res://scenes/entities/whirlpool.tscn")

#roe popup
@onready var roePopup = load("res://scenes/objects/roe_popup.tscn")




func _ready() -> void:
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = false
	add_child(thunkfade)
	
	globalSignals.game2toR.connect(fadeaway)
	globalSignals.connect("boss2death", boss2clear)
	global.pausable = true
	globalSignals.boss2Start.connect(bossStart)
	
	#pause_menu.pausable = true
	$"ambience".play()
	pass 

func boss2clear():
	$Music/musicInt.stop()
	$Music/musicLoop.stop()
	$Music/musicEnd.play()
	fan.turnOff()
	var instance = clearpopup.instantiate()
	add_child(instance)
	
	#roe popup
	var roeP = roePopup.instantiate()
	roeP.global_position = fish.global_position
	roeP.actualText = "+"+str(20)
	global.roe += 20
	rng.randomize()
	roeP.global_position.x += randf_range(-1000,1000)
	rng.randomize()
	roeP.global_position.y += randf_range(-1000,1000)
	add_child(roeP)
	
	#sapawning portal
	await get_tree().create_timer(2, false).timeout
	var portal = whirlpool.instantiate()
	global.whirlPoolPos = Vector2(17000, -20000)
	portal.global_position = global.whirlPoolPos
	add_child(portal)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (fish.global_position.x < 16000 && fanOn && !fish.mult > 1):
		fish.global_position.x += fanSpeed
		
	pass
	
	

func _on_ambience_finished() -> void:
	$"ambience".play()

func bossStart():
	
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
	
	
