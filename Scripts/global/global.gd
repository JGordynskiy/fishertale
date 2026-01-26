extends Node
@onready var current_scene = null
@onready var inGame = false
var debug = false

#1 is default, 2 is melee
var heart = 0


@export var speed = 7000
@export var shot_rate = 400 # 400 as default, reduce to increase
@export var slash_rate = 400
@export var shot_damage = 1.5 # 1.5 default
@export var slash_damage = shot_damage*3  # 3 default
var max_hp = 5
var hp = max_hp

#upgrades and costs
var roe = 0
var damageCost = 5
var rateCost = 5
var healthCost = 1

var accuracy = 0# 0.1 default, decrease to increase
var bulletRange = 200 
var pausable = false
@export var camZoom = 0.06 # 0.06 default
@export var curBoss = 0

var whirlPoolPos : Vector2



#signal pause
#signal unPause




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globalSignals.connect("gameTtoR", transition_TutR)
	globalSignals.connect("gameRto1", transition_Rone)
	globalSignals.connect("game1toR", transition_OneR)
	globalSignals.connect("gameRto2", transition_Rtwo)
	
	
	var root = get_tree().root
	#This gets the last child node of "root" 
	current_scene = root.get_child(-1)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.

func goto_scene(path):
	#Deferred means it's only called once all the other code in the scene is finished
	#We need to do this to avoid crashes
	_deferred_goto_scene.call_deferred(path)
	
func wait(time : float):
	await get_tree().create_timer(time).timeout
	
func _deferred_goto_scene(path):
	current_scene.free()
	var s = load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DEBUGaddhp"):
			if global.hp < 5:
				global.hp += 1
				
	DisplayServer.window_set_title(str(Engine.get_frames_per_second()))
	
	if global.hp == 0:
		globalSignals.gameOver.emit()
		global.hp = -1
		
	pass
	
func transition_TutR():
	await get_tree().create_timer(1.5, false).timeout
	goto_scene("res://scenes/levels/respite_menu.tscn")
	pass

func transition_Rone():
	await get_tree().create_timer(1, false).timeout
	goto_scene("res://scenes/levels/game1.tscn")
	pass
func transition_OneR():
	await get_tree().create_timer(1.5, false).timeout
	goto_scene("res://scenes/levels/respite_menu.tscn")
	pass
func transition_Rtwo():
	await get_tree().create_timer(1, false).timeout
	goto_scene("res://scenes/levels/game2.tscn")
	pass
