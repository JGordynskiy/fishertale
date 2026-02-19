extends CharacterBody2D

var type
var range = 100
var curRange = 0
var speed = 6000

var dir = 0

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$streak.pitch_scale = rng.randf_range(0.8, 1.2)
	pass # Replace with function body.

func explode():
	$streak.stop()
	$explode.emitting = true
	$trail.emitting = false
	$Node2D.visible = false
	$Node2D/Sprite2D/Area2D/CollisionPolygon2D.disabled = true
	await get_tree().create_timer(2, false).timeout
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if curRange > range:
		curRange = -1
		velocity = Vector2(0, 0)
		explode()
		
		
	else:
		if (type == 0):
			velocity = Vector2(speed, 0).rotated(dir)
			dir += delta*PI
		if (type == 1):
			if curRange > 0:
				velocity = Vector2(speed, 0).rotated(dir)
	if curRange >= 0:
		curRange += 1
	move_and_slide()
	pass


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$trail.emitting = true
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$trail.emitting = false
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		
		curRange = range + 1
		global_position = body.global_position
		pass # Replace with function body.
