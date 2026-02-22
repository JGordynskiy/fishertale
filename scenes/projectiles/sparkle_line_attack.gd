extends Node2D

@onready var sparkle = load("res://scenes/projectiles/sparkle.tscn")

@onready var game = get_node("../..")

@onready var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Line2D/AnimationPlayer.play("fadeIn")
	await get_tree().create_timer(0.5, false).timeout
	$Line2D/AnimationPlayer.play("fadeOut")
	shoot()
	await get_tree().create_timer(5, false).timeout
	queue_free()
	pass # Replace with function body.


func shoot():
	rng.randomize()
	var instance = sparkle.instantiate()
	instance.global_position = global_position
	instance.dir = global_rotation
	instance.global_rotation = randf_range(0, 2*PI)
	instance.type = 1
	instance.speed = 50000
	await get_tree().create_timer(randf_range(0, 0.2), false).timeout
	game.add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
