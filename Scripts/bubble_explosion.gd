extends Node2D

@onready var game = get_tree().get_current_scene()
@onready var fish = game.get_node("fish")
var particleTime
var particleCount
var pos : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = pos
	
	$CPUParticles2D.lifetime = particleTime
	$CPUParticles2D.amount = particleCount
	
	$CPUParticles2D.emitting = true
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cpu_particles_2d_finished() -> void:
	queue_free()
	pass # Replace with function body.
