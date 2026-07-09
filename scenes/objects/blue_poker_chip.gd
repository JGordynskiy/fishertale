extends CharacterBody2D

var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$spawnPart.emitting = true
	await global.timer(0.5)
	
	$noise.pitch_scale = randf_range(0.95, 1.05)
	$noise.play()
	$Sprite2D/AnimationPlayer.play("spawn")
	$spawnPart2.emitting = true
	velocity.y = randf_range(-7000, -10000)
	velocity.x = randf_range(-3500, 3500)
	$trail.emitting = true
	
	await global.timer(0.3)
	
	
	$Area2D.monitorable = true
	$Area2D.monitoring = true
	active = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		velocity.y += 18000*delta
	pass
	move_and_slide()
	
	if global_position.y > 50000:
		queue_free()
