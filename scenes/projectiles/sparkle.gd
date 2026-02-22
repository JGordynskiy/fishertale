extends CharacterBody2D


## type 0: spinning
## type 1: short-lived straight
## type 2: long-lived straight
var type : int
@warning_ignore("shadowed_global_identifier")
var range : int
var curRange = 0
var speed : int

@onready var cam = get_viewport().get_camera_2d()

var dir = 0

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$streak.pitch_scale = rng.randf_range(0.8, 1.2)
	
	if type == 0:
		range = 300
	if type == 1:
		range = 120
		$PointLight2D.shadow_enabled = false
	if type == 2:
		range = 300
	pass # Replace with function body.

func explode():
	$streak.stop()
	$explode.emitting = true
	$trail.emitting = false
	$Node2D.visible = false
	await get_tree().physics_frame
	$Node2D/Sprite2D/Area2D/CollisionPolygon2D.disabled = true
	await get_tree().create_timer(1.5, false).timeout
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if curRange > range:
		curRange = -1
		velocity = Vector2(0, 0)
		explode()
	else:
		if (type == 0):
			if curRange > 0:
				velocity = Vector2(speed, 0).rotated(dir)
				dir += delta*PI*5/3
				@warning_ignore("narrowing_conversion")
				speed *= 1.01
		if (type == 1 || type == 2):
			if curRange > 0:
				velocity = Vector2(speed, 0).rotated(dir)
	if curRange >= 0:
		curRange += 1
		
	if cam != null && global_position.distance_to(cam.global_position) > 20000:
		$trail.emitting = false
		$explode.emitting = false
	else:
		if curRange > 0:
			$trail.emitting = true
	move_and_slide()
	pass

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	#$trail.emitting = true
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await get_tree().create_timer(0.2, false).timeout
	$trail.emitting = false
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		curRange = range + 1
		global_position = body.global_position
		speed = 0

	if body.is_in_group("objects") && type != 1:
		curRange = range + 1
		#global_position = body.global_position
		speed = 0
	
		pass # Replace with function body.
