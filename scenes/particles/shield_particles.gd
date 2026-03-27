extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await global.timer(0.02)
	if global.shield > 0:
		lifetime = 1.0
		amount = 50
	else:
		lifetime = 2.0
		amount = 150
	
	emitting = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
