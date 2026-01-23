extends Node2D

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var game = get_tree().get_current_scene()
@onready var fish = game.get_node("fish")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = fish.position
	rotation = fish.rotation + PI/2
	
	animation_player.play("new_animation")
	await get_tree().create_timer(0.5).timeout
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
