extends Node2D
@onready var fadeRect = preload("res://scenes/ui/fade_rect.tscn")

@onready var playerCam: Camera2D = $fish/followCam
@onready var fish: CharacterBody2D = $fish

var inBlack = false
var inRed = false
var inGreen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fadeIn()
	global.pausable = true
	playerCam.zoom.x = 0.04
	playerCam.zoom.y = 0.04
	
	globalSignals.connect("justPaused", pauseGame)
	globalSignals.connect("justUnPaused", unpauseGame)
	globalSignals.connect("gameOver", gameOver)
	globalSignals.connect("boss5death", bossclear)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if inBlack:
		$debug/inBlack.text = "inBlack: yes"
	else:
		$debug/inBlack.text = "inBlack: no"
		
	if inRed:
		$debug/inRed.text = "inRed: yes"
	else:
		$debug/inRed.text = "inRed: no"
		
	if inGreen:
		$debug/inGreen.text = "inGreen: yes"
	else:
		$debug/inGreen.text = "inGreen: no"
	pass

func pauseGame():
	$music/intro.bus = "lowpass"
	$music/loop.bus = "lowpass"
	
func unpauseGame():
	$music/intro.bus = "Music"
	$music/loop.bus = "Music"

func bossclear():
	await global.timer(1.5)
	get_tree().change_scene_to_file("res://scenes/levels/end_cutscene.tscn")
	pass

func gameOver():
	var tween = get_tree().create_tween()
	tween.tween_property($music/loop, "pitch_scale", 0, 3)
	var tween2 = get_tree().create_tween()
	tween2.tween_property($music/intro, "pitch_scale", 0, 3)
	await global.timer(3)
	$music/loop.stop()
	$music/intro.stop()

func fadeIn():
	var instance = fadeRect.instantiate()
	instance.type = false
	add_child(instance)
	
func fadeOut():
	await global.timer(0.5)
	var instance = fadeRect.instantiate()
	instance.type = true
	add_child(instance)


func _on_intro_finished() -> void:
	$music/loop.play()
	pass # Replace with function body.
