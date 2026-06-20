extends Node2D

@onready var game = get_tree().current_scene
@onready var fish = game.fish

var spinSpeed = 0

var spinning = false
signal spinFinish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	$wheelTopShadow.global_rotation = $wheelTop.global_rotation
	
	$wheel.global_rotation += spinSpeed*delta
	$wheelTop.global_rotation -= spinSpeed*delta
	
	
	if spinSpeed > 0.04:
		spinSpeed -= 0.04
	elif spinSpeed < -0.04:
		spinSpeed += 0.04
	else:
		spinSpeed = 0
		if spinning:
			spinning = false
			globalSignals.emit_signal("wheelFinish")


func spin():
	spinning = true
	spinSpeed = randf_range(8, 12)
	
	var rand = 0
	while rand == 0:
		rand = randi_range(-1, 1)
	spinSpeed *= rand
	$spin.pitch_scale = randf_range(1.2, 1.5)
	$spin.play()
	pass

func popOut():
	$wheelTop.z_index = 500
	$pushAway/AnimationPlayer.play("push")
	$wheelTop/StaticBody2D/CollisionPolygon2D.set_deferred("disabled", false)
	$cloud/AnimationPlayer.play("poof")
	$woodSlam.play()
	$wheelTopShadow.show()
	
	await get_tree().create_timer(0.15, false).timeout
	$pushAway/AnimationPlayer.play("RESET")
	
func popIn():
	$spin.stop()
	$wheelTop.z_index = 0
	$wheelTop/StaticBody2D/CollisionPolygon2D.set_deferred("disabled", true)
	$cloud/AnimationPlayer.play("poof")
	$woodSlam.play()
	$wheelTopShadow.hide()


func _on_red_area_entered(area: Area2D) -> void:
	if area.name == "fish":
		game.inRed = true
func _on_red_area_exited(area: Area2D) -> void:
	if area.name == "fish":
		game.inRed = false

func _on_black_area_entered(area: Area2D) -> void:
	if area.name == "fish":
		game.inBlack = true
func _on_black_area_exited(area: Area2D) -> void:
	if area.name == "fish":
		game.inBlack = false

func _on_green_area_entered(area: Area2D) -> void:
	if area.name == "fish":
		game.inGreen = true
func _on_green_area_exited(area: Area2D) -> void:
	if area.name == "fish":
		game.inGreen = false
