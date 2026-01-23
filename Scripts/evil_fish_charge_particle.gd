extends Node2D

@onready var game = get_tree().get_current_scene()
@onready var evilFish = game.get_node("evilFish")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$bulletcharge.emitting = true
	await get_tree().create_timer(0.5, false).timeout
	$splosion.emitting = true
	await get_tree().create_timer(1, false).timeout
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = evilFish.global_position
	pass
