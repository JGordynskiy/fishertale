extends Node2D
@onready var spawn: AnimationPlayer = $spawn
@onready var spawnsplosion: GPUParticles2D = $spawnsplosion
@onready var vortex: GPUParticles2D = $vortex
@onready var whirlpoolnoise: AudioStreamPlayer2D = $whirlpoolnoise
@onready var whirlpoolspawn: AudioStreamPlayer = $whirlpoolspawn

@onready var cam = $"../fish/followCam"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	spawn.play("spawn")
	whirlpoolnoise.play()
	whirlpoolspawn.play()
	
	spawnsplosion.emitting = true
	await get_tree().create_timer(0.05, false).timeout
	visible = true
	
	await get_tree().create_timer(1, false).timeout
	vortex.emitting = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if (area.name == "fish"):
		global.pausable = false
		if cam.tutorial:
			globalSignals.emit_signal("gameTtoR")
			return
		match global.curBoss:
			1:
				globalSignals.emit_signal("game1toR")
				global.pausable = true
			2: 
				globalSignals.emit_signal("game2toR")
	pass # Replace with function body.
