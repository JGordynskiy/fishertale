extends CharacterBody2D
@onready var game = $".."
@onready var fish: CharacterBody2D = $"../fish"

var advanced : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var count = 0
	global_position = Vector2(randf_range(-2500, 18000), randf_range(4000, 24000))
	# global_position.distance_to(fish.global_position) < 9000 || !$VisibleOnScreenNotifier2D.is_on_screen()
	while (true):
		global_position = Vector2(randf_range(-2500, 18000), randf_range(4000, 24000))
		await get_tree().process_frame
		if !$VisibleOnScreenNotifier2D.is_on_screen():
			count += 1
			print_debug("rettry, not on screen")
			continue
		if global_position.distance_to(fish.global_position) > 7000:
			break
		count += 1
		print_debug("retry, too close")
		
	if count >= 15:
		queue_free()
		
	$spawnNoise.pitch_scale = (randf_range(0.95, 1.05))
	$spawnNoise.play()
	$Sprite2D/AnimationPlayer.play("fadeIn")
	
	
	look_at(fish.global_position)
	global_rotation += randf_range(-0.1, 0.1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_slide()
	if global_position.distance_to(fish.global_position) > 45000:
		queue_free()
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if advanced:
		velocity = Vector2(randf_range(15000, 22000), 0).rotated(global_rotation)
	else:
		velocity = Vector2(15000, 0).rotated(global_rotation)
	$GPUParticles2D.emitting = true
	$Area2D.monitorable = true
	$Area2D.monitoring = true
	pass # Replace with function body.
