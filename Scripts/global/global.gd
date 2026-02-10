extends Node
@onready var current_scene = null
@onready var inGame = false
var debug = false

var debugCounter = 0
#1 is default, 2 is melee
var heart = 1

## STATS MUST BE CHANGED IN MAIN_MENU.GD
@export var speed = 7000
@export var shot_rate = 400 # 400 as default, reduce to increase
@export var shot_damage = 1.5 # 1.5 default
@export var slash_damage = shot_damage*2  # 2 default
@export var slash_rate = 400

var slash_scale = 1.2

var max_hp = 5
var hp = max_hp

var stopwatch = 0

#upgrades and costs
var roe = 0
var damageCost = 4
var rateCost = 4
var healthCost = 1

var accuracy = 0# 0.1 default, decrease to increase
var bulletRange = 250 
var pausable = false
@export var camZoom = 0.06 # 0.06 default, dmgSplash stops working at 0.01!
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
	globalSignals.connect("game2toR", transition_twoR)
	
	globalSignals.connect("gameRto3", transition_Rthree)
	globalSignals.connect("game3toR", transition_threeR)
	
	
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
	if is_instance_valid(current_scene):
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
	curBoss = 1
	goto_scene("res://scenes/levels/respite_menu.tscn")
	pass

func transition_Rone():
	await get_tree().create_timer(1, false).timeout
	goto_scene("res://scenes/levels/game1.tscn")
	pass
	
	
func transition_OneR():
	await get_tree().create_timer(1.5, false).timeout
	curBoss = 2
	goto_scene("res://scenes/levels/respite_menu.tscn")
	pass
func transition_Rtwo():
	await get_tree().create_timer(1, false).timeout
	goto_scene("res://scenes/levels/game2.tscn")
	pass
	
	
func transition_twoR():
	curBoss = 3
	await get_tree().create_timer(1, false).timeout
	goto_scene("res://scenes/levels/respite_menu.tscn")
func transition_Rthree():
	await get_tree().create_timer(1, false).timeout
	goto_scene("res://scenes/levels/game3.tscn")
	
	
func transition_threeR():
	curBoss = 4
	await get_tree().create_timer(1.5, false).timeout
	goto_scene("res://scenes/levels/respite_menu.tscn")
