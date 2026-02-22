extends Node2D

@onready var fadeRect = load("res://scenes/ui/fade_rect.tscn")
@onready var clearPopup = load("res://scenes/ui/clearpopup.tscn")
@onready var whirlpool = load("res://scenes/entities/whirlpool.tscn")
@onready var roePopup = load("res://scenes/objects/roe_popup.tscn")

@onready var fish: CharacterBody2D = $fish
@onready var lightfish: Node2D = $lightFish

@onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.physics_ticks_per_second = 120
	$fish/followCam.zoom.y = 0.05
	$fish/followCam.zoom.x = 0.05
	
	$darkness.visible = false
	globalSignals.connect("boss4death", clear)
	globalSignals.connect("game4toR", fadeOut)
	
	fadeIn()
	global.pausable = true
	await global.timer(1)
	await flickerOff()
	pass # Replace with function body.

func clear():
	var instance = clearPopup.instantiate()
	add_child(instance)
	
	var roeP = roePopup.instantiate()
	roeP.global_position = fish.global_position
	roeP.actualText = "+"+str(15)
	global.roe += 15
	rng.randomize()
	roeP.global_position.x += randf_range(-1000,1000)
	rng.randomize()
	roeP.global_position.y += randf_range(-1000,1000)
	add_child(roeP)
	
	await global.timer(3)
	
	
	
	var instance2 = whirlpool.instantiate()
	global.whirlPoolPos = Vector2(33880, -21430)
	instance2.global_position = global.whirlPoolPos
	instance2.z_index = 400
	add_child(instance2)
	
	await global.timer(2)
	flickerOn()

func fadeIn():
	var instance = fadeRect.instantiate()
	instance.type = false
	add_child(instance)
	
func fadeOut():
	await global.timer(0.5)
	var instance = fadeRect.instantiate()
	instance.type = true
	add_child(instance)

func flickerOff():
	var tween = get_tree().create_tween()
	
	$darkness.visible = true
	await global.timer(0.03)
	$darkness.visible = false
	
	
	await global.timer(1)
	
	for i in range(3):
		$darkness.visible = true
		await global.timer(0.03)
		$darkness.visible = false
		await global.timer(0.03)
	
	await global.timer(0.5)
	
	for i in range(6):
		$darkness.visible = true
		await global.timer(0.03)
		$darkness.visible = false
		await global.timer(0.03)
		
	$darkness.visible = true

func flickerOn():

	for i in range(4):
		$darkness.visible = true
		await global.timer(0.03)
		$darkness.visible = false
		await global.timer(0.03)
		
	$darkness.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
