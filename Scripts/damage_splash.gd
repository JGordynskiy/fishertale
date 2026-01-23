extends Node2D

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

@onready var root_level = get_tree().get_current_scene()
@onready var fish = root_level.get_node("fish") 
# this is better, because it'll take the top node of the scene
# (The "level scene") and go from there. Only downside to this is
# the fish must always be directly connected to the root level, or else
# it won't find it. You could also use the exact same file apth for each level, too.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("fade_out")
	modulate.a = 10
	visible = true
	
	
	

	position = fish.position
	await get_tree().create_timer(1.5).timeout
	queue_free()
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
