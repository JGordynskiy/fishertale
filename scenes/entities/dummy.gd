extends Node2D


@onready var game = get_owner()

var iFrames = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	iFrames -= 60*delta
	if iFrames > 0:
		modulate.v = 0.5
	else:
		modulate.v = 1
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if iFrames < 0:
		if area.is_in_group("playerBullet") || area.is_in_group("playerSlash"):
			iFrames = 4
			if area.is_in_group("playerSlash"):
				globalSignals.slashSuccess.emit()
	pass # Replace with function body.
