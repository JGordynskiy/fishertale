extends CanvasLayer
@onready var healthBar: ProgressBar = $ProgressBar
@onready var game = get_owner()
@onready var boss2 = game.get_node("Wallfish")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthBar.max_value = boss2.boss2hp
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthBar.value = boss2.boss2hp
	
	if healthBar.value <= 0:
		hide()
	else:
		show()
	pass
