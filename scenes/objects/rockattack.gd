extends CharacterBody2D
@onready var bubbletrail: GPUParticles2D = $Projectile/bubbletrail
@onready var warning: Sprite2D = $"Projectile/Warning laser"

@onready var voosh: AudioStreamPlayer2D = $Projectile/voosh
@onready var boom: AudioStreamPlayer2D = $Projectile/boom
@onready var chargesfx: AudioStreamPlayer = $"Projectile/charge"

@onready var rng = RandomNumberGenerator.new()

var startx # These 4 must be declared
var endx
var yrange1
var yrange2

var amWarning = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var starty
	var endy
	rng.randomize()
	endy = randf_range(yrange1, yrange2)
	rng.randomize()
	starty = randf_range(yrange1, yrange2)
	
	global_position = Vector2(startx, starty)
	
	look_at(Vector2(endx, endy))
	
	#Setup done
	#Warning laser
	warning.self_modulate.a = 0
	rng.randomize()
	chargesfx.pitch_scale = rng.randf_range(1.7, 2.1)
	chargesfx.play()
	
	await get_tree().create_timer(1, false).timeout
	
	amWarning = false
	warning.self_modulate.a = 0
	
	#actually throw rock
	bubbletrail.emitting = true
	look_at(Vector2(endx, endy))
	velocity = Vector2(35000, 0).rotated(global_rotation)
	rng.randomize()
	voosh.pitch_scale = rng.randf_range(0.8, 1.2)
	boom.pitch_scale = rng.randf_range(0.8, 1.2)
	voosh.play()
	boom.play()
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global_position.x > endx:
		velocity = Vector2(0, 0)
		bubbletrail.emitting = false
		voosh.stop()
		await get_tree().create_timer(5, false).timeout
		queue_free()
		pass
	if amWarning:
		warning.self_modulate.a += 1*delta
	
	move_and_slide()
