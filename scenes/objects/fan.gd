extends Node2D
@onready var game2: Node2D = $".."
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles: CPUParticles2D = $windParts
@onready var bubbleparts: CPUParticles2D = $bubbleparts
@onready var wallfish = $"../Wallfish"
@onready var fan_ambience: AudioStreamPlayer2D = $"Fan ambience"
@onready var fan_startup: AudioStreamPlayer2D = $"fan Startup"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	particles.speed_scale = (game2.fanSpeed/30.0)/2.0
	bubbleparts.speed_scale = (game2.fanSpeed/30.0)/2.0
	
	if (game2.wallfish.boss2hp > 0):
		fan_ambience.pitch_scale = game2.fanSpeed/30.0
	
	pass
	
func turnOn():
	fan_startup.play()
	animation.play("spin")
	animation.speed_scale = 0
	var tween = create_tween()
	tween.tween_property(animation, "speed_scale", 1, 2)
	
	await get_tree().create_timer(1, false).timeout
	game2.fanOn = true
	
	
	#await get_tree().create_timer(1.5, false).timeout
	particles.emitting = true
	#bubbleparts.emitting = true
	
	globalSignals.boss2Start.emit()

func turnOff():
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(animation, "speed_scale", 0, 2)
	particles.emitting = false
	bubbleparts.emitting = false
	game2.fanOn = false
	tween2.tween_property(fan_ambience, "pitch_scale", 0, 5)
	await get_tree().create_timer(8, false).timeout
	fan_ambience.stop()
	
	
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.is_in_group("player") || area.is_in_group("playerBullet")):
		if (wallfish.boss2hp > 0 && !game2.fanOn):
			
			
			turnOn()
	pass # Replace with function body.

func _on_fan_startup_finished() -> void:
	fan_ambience.play()
	pass # Replace with function body.
