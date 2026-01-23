extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $area2d/AnimatedSprite2D

var curRange = 0



var range : int
var spawnPos : Vector2
var spawnRot : float
var dir : float
var shotspeed : int

var popped = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	animated_sprite_2d.play("shoot")
	$shoot.play()
	
	global_rotation = spawnRot + (PI)
	dir += 3*PI/2
	curRange = 0
	global_position = spawnPos
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if curRange < range:
		velocity = Vector2(0, -shotspeed).rotated(dir)
	curRange += 10
	
	if curRange > range:
		pop()
	pass
	move_and_slide()
	
	
func pop():
	
	if popped == 0:
		popped = 1
		velocity = Vector2(0, 0)
		animated_sprite_2d.play("pop")
		$pop.play()
		
		await get_tree().create_timer(0.1).timeout
		queue_free()
	
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("objects") || body.is_in_group("player"):
		
		if (body.name == "CannonBody"):
			return
		if (body.is_in_group("enemies")):
			return
		
		curRange = 999999
		if body.is_in_group("player"):
			globalSignals.takeDmg.emit()
	
	pass # Replace with function body.
