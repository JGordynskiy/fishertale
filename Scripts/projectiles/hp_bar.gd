extends CanvasLayer
@onready var sprite_2d: Sprite2D = $Panel/Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global.hp > 5:
		sprite_2d.frame = 5
	else:
		if global.hp > 0:
			sprite_2d.frame = global.hp
		else:
			sprite_2d.frame = 0
