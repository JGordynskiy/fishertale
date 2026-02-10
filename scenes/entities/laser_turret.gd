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
	if !boss3.turreting:
		look_at(fish.global_position)

	pass

func shoot():
	boss3.turreting = true
	$visual.modulate.a = 0.4
	for i in range(15):
		$visual.visible = !$visual.visible
		await get_tree().create_timer(0.04, false).timeout
	for i in range(20):
		$visual.visible = !$visual.visible
		await get_tree().create_timer(0.01, false).timeout
	$visual.modulate.a = 1
	$visual.visible = true
	$Area2D.monitorable = true
	
	await get_tree().create_timer(0.2, false).timeout
	
	$Area2D.monitorable = false
	$visual.visible = false
	await get_tree().create_timer(0.01, false).timeout
	boss3.turreting = false
