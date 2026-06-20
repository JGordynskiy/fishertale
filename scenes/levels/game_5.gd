extends Node2D

@onready var playerCam: Camera2D = $fish/followCam
@onready var fish: CharacterBody2D = $fish

var inBlack = false
var inRed = false
var inGreen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.pausable = true
	playerCam.zoom.x = 0.05
	playerCam.zoom.y = 0.05
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
