extends Node2D
@onready var game: Node2D = $"../.."
@onready var fish = game.get_node("fish")
@onready var boss3 = game.get_node("laserFish")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$visual.visible = false
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shoot():
	look_at(fish.global_position)
	boss3.turreting = true
	$visual.modulate.a = 0.4
	for i in range(15):
		$visual.visible = !$visual.visible
		await get_tree().create_timer(0.06, false).timeout
		$AudioStreamPlayer2D.play()
	for i in range(20):
		$visual.visible = !$visual.visible
		await get_tree().create_timer(0.03, false).timeout
		$AudioStreamPlayer2D.play()
	$visual.modulate.a = 1
	$visual.visible = true
	$shoot.play()
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	
	await get_tree().create_timer(0.2, false).timeout
	
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$visual.visible = false
	await get_tree().create_timer(0.05, false).timeout
	boss3.turreting = false
