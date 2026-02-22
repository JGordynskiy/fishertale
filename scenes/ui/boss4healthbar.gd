extends CanvasLayer
@onready var healthBar: ProgressBar = $ProgressBar
@onready var game = get_owner()
@onready var boss4 = game.get_node("lightFish")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	healthBar.max_value = boss4.boss4hp
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthBar.value = boss4.boss4hp
	
	if healthBar.value <= 0:
		hide()
	else:
		show()
	pass
