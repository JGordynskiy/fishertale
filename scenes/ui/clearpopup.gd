extends CanvasLayer
@onready var animation_player: AnimationPlayer = $Label/AnimationPlayer

@export var active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if active:
		animation_player.play("popup")
	else:
		hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
