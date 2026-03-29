extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss3parts()
	boss2parts()
	await global.timer(4)
	queue_free()
	pass # Replace with function body.

func boss3parts():
	$particles/boss3/deathparticle2.emitting = true
	$particles/boss3/deathParticle1.emitting = true
	$particles/boss3/steam2.emitting = true
	$particles/boss3/steam1.emitting = true
	$particles/boss3/laserTelegraph.emitting = true
	
func boss2parts():
	$particles/boss2/deathParticles.emitting = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
