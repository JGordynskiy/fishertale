extends Node2D
@onready var fadeRect = load("res://scenes/ui/fade_rect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = false
	add_child(thunkfade)
	global.pausable = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
