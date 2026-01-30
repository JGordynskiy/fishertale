extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.debug = true
	global.pausable = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("one"):
		global.heart = 1
	if Input.is_action_just_pressed("two"):
		global.heart = 2
		
	if Input.is_action_just_pressed("scrollUp"):
		if $fish/followCam.zoom.x < 0.5:
			$fish/followCam.zoom.x += 0.01
			$fish/followCam.zoom.y += 0.01
	if Input.is_action_just_pressed("scrollDown"):
		if $fish/followCam.zoom.x > 0.02:
			$fish/followCam.zoom.x -= 0.01
			$fish/followCam.zoom.y -= 0.01
	pass
