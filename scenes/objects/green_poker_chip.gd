extends CharacterBody2D

@onready var game = get_tree().current_scene
@onready var boss5 = game.get_node("boss5")
@onready var fish = game.get_node("fish")
var active = false

var collected = false

var dangerous = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$spawnPart.emitting = true
	await global.timer(0.5)
	
	$noise.pitch_scale = randf_range(0.95, 1.05)
	$noise.play()
	$Sprite2D/AnimationPlayer.play("spawn")
	$spawnPart2.emitting = true
	velocity.y = randf_range(-7000, -10000)
	velocity.x = randf_range(-1500, 1500)
	$trail.emitting = true
	
	await global.timer(0.3)
	$greenChip.monitorable = true
	$greenChip.monitoring = true
	active = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		velocity.y += 12000*delta
	pass
	if !collected:
		move_and_slide()
	if global_position.y > 50000:
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "fish" && dangerous:
		globalSignals.emit_signal("takeDmg")
	
	if area.name == "fish" && !collected && !dangerous:
		collected = true
		$Sprite2D.hide()
		$spawnPart2.restart()
		$spawnPart2.emitting = true
		
		$collect.pitch_scale = randf_range(0.95, 1.05)
		$collect.play()
		$trail.emitting = false
		velocity = Vector2(0, 0)
		
		
		await global.timer(1)
		queue_free()
	if area.name == "greenChipCheck" && !dangerous:
		
		$trail.emitting = false
		globalSignals.emit_signal("takeDmg")
		collected = true
		global_position = fish.global_position
		$Sprite2D/AnimationPlayer.play("howSad")
		
		await global.timer(1)
		queue_free()
		
	pass # Replace with function body.
