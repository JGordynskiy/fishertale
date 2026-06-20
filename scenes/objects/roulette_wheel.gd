extends Node2D

@onready var game = get_tree().current_scene
@onready var fish = game.fish

var spinSpeed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2, false).timeout
	popOut()
	await get_tree().create_timer(0.5, false).timeout
	spinRed()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	print_debug(spinSpeed)
	
	$wheelTopShadow.global_rotation = $wheelTop.global_rotation
	
	$wheel.global_rotation += spinSpeed*delta
	$wheelTop.global_rotation -= spinSpeed*delta
	
	
	if spinSpeed > 0.03:
		spinSpeed -= 0.03
	elif spinSpeed < -0.03:
		spinSpeed += 0.03
	else:
		spinSpeed = 0


func spinRed():
	
	spinSpeed = randf_range(8, 8)
	$spin.pitch_scale = 1.2
	$spin.play()
	pass

func popOut():
	$pushAway/AnimationPlayer.play("push")
	$wheelTop/StaticBody2D/CollisionPolygon2D.set_deferred("disabled", false)
	$cloud/AnimationPlayer.play("poof")
	$woodSlam.play()
	$wheelTopShadow.show()
	
	await get_tree().create_timer(0.15, false).timeout
	$pushAway/AnimationPlayer.play("RESET")
	
func popIn():
	$wheelTop/StaticBody2D/CollisionPolygon2D.set_deferred("disabled", true)
	$cloud/AnimationPlayer.play("poof")
	$woodSlam.play()
	$wheelTopShadow.hide()
