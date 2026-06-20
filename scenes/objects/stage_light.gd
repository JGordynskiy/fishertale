extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_rotation -= 0.15
	var tween
	var swingTime : float
	while true:
		swingTime = randf_range(1.5, 3)
		
		tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "global_rotation", global_rotation+0.3, swingTime).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		
		if tween:
			tween.kill()
		
		tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "global_rotation", global_rotation-0.3, swingTime).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
