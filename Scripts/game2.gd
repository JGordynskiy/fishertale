extends Node2D
@onready var pause_menu: Control = $"Pause Menu/CanvasLayer"
@onready var fish = get_node("fish") 
var fanSpeed : float = 30
var fanOn = false
@onready var wallfish: CharacterBody2D = $Wallfish
@onready var fan: Node2D = $fan

@onready var faderect: AnimationPlayer = $faderect/faderect/AnimationPlayer
@onready var clearpopup = load("res://scenes/ui/clearpopup.tscn")




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	faderect.play("fadein")
	global.curBoss = 2
	globalSignals.connect("boss2death", boss2clear)
	global.pausable = true
	globalSignals.boss2Start.connect(bossStart)
	
	#pause_menu.pausable = true
	$"ambience".play()
	pass # Replace with function body.

func boss2clear():
	fan.turnOff()
	var instance = clearpopup.instantiate()
	add_child(instance)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (fish.global_position.x < 16000 && fanOn && !fish.mult > 1):
		fish.global_position.x += fanSpeed
		
	pass
	
	

func _on_ambience_finished() -> void:
	$"ambience".play()

func bossStart():
	pass
