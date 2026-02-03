extends CharacterBody2D

@onready var game = get_tree().get_current_scene()
@onready var bullet = load("res://scenes/enemy_bullet.tscn")

# Called when the node enters the scene tree for the first time.
var range : int
var spawnPos : Vector2
var spawnRot : float
var dir : float
var shotspeed : int

var curRange : int

var popped = false
func _ready() -> void:
	dir += PI/2
	popped = false
	$AnimatedSprite2D.play("default")
	$shoot.play()
	
	global_position = spawnPos
	global_rotation = spawnRot
	curRange = 0
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if curRange < range:
		velocity = Vector2(0, -shotspeed).rotated(dir)
	
	
	curRange += 10
	
	if curRange > range && !popped:
		popped = true
		pop()
	move_and_slide()
	
	pass
func pop():
	velocity = Vector2(0,0)
	$AnimatedSprite2D.play("pop")
	await get_tree().create_timer(0.1).timeout
	shoot(0)
	shoot(PI/4)
	shoot(2*PI/4)
	shoot(3*PI/4)
	shoot(4*PI/4)
	shoot(5*PI/4)
	shoot(6*PI/4)
	queue_free()
	
func shoot(rot):
	var instance = bullet.instantiate()
	instance.range = 1500
	instance.spawnPos = global_position
	instance.spawnRot = rot
	instance.dir = rot
	instance.shotspeed = 10000
	
	game.add_child(instance)


func _on_super_bullet_body_entered(body: Node2D) -> void:
	if body.is_in_group("objects") || body.is_in_group("player") || body.is_in_group("playerBullet"):
		curRange = range
	pass # Replace with function body.
