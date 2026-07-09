extends CanvasLayer
@onready var healthBar: ProgressBar = $ProgressBar
@onready var game = get_owner()
@onready var boss5 = game.get_node("boss5")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthBar.max_value = boss5.boss5hp



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthBar.value = boss5.boss5hp
	if healthBar != null:
		if healthBar.value <= 0:
			hide()
		else:
			show()
	pass
