extends Node2D

@onready var game = get_tree().current_scene
@onready var fish = game.fish

var spinSpeed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1, false).timeout
	spinRed()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	print_debug(spinSpeed)
	
	#$wheelTopShadow.global_rotation = $wheelTop.global_rotation
	
	global_rotation += spinSpeed*delta
	$wheelTop.global_rotation -= spinSpeed*delta * 2
	
	if spinSpeed != 0:
		if spinSpeed > 0:
			spinSpeed -= 0.01
		if spinSpeed < 0:
			spinSpeed += 0.01


func spinRed():
	spinSpeed = 5
	pass
