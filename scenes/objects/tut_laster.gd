extends Node2D

@onready var game = get_owner()
@onready var fish = game.get_node("fish") 

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fish.mult > 2:
		collision_shape_2d.disabled = true
	else:
		collision_shape_2d.disabled = false
	pass
