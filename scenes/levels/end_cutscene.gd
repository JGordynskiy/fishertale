extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect2/Label2.text = str(global.score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
