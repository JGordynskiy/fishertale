extends Node2D
@onready var fadeRect = load("res://scenes/ui/fade_rect.tscn")
@onready var roePopup = load("res://scenes/objects/roe_popup.tscn")
@onready var fish = get_node("fish")
@onready var whirlpool = load("res://scenes/entities/whirlpool.tscn")

@onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.pausable = true
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = false
	add_child(thunkfade)
	global.pausable = true
	
	globalSignals.connect("boss3death", spawnPortal)
	globalSignals.connect("game3toR", transition)
	pass 
	
func transition():
	global.pausable = false
	await get_tree().create_timer(1, false).timeout
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = true
	add_child(thunkfade)
func spawnPortal():
	#give roe
	var roeP = roePopup.instantiate()
	roeP.global_position = fish.global_position
	roeP.actualText = "+"+str(15)
	global.roe += 15
	rng.randomize()
	roeP.global_position.x += randf_range(-1000,1000)
	rng.randomize()
	roeP.global_position.y += randf_range(-1000,1000)
	add_child(roeP)
	
	await get_tree().create_timer(3, false).timeout
	
	var portal = whirlpool.instantiate()
	global.whirlPoolPos = Vector2(17000, -9000)
	portal.global_position = global.whirlPoolPos
	add_child(portal)
	pass


func _process(delta: float) -> void:
	pass
