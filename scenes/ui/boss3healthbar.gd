extends CanvasLayer
@onready var healthBar: ProgressBar = $ProgressBar
@onready var game = get_owner()
@onready var boss3 = game.get_node("laserFish")
#var style_box: StyleBoxFlat = get_theme_stylebox("ProgressBar")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthBar.max_value = boss3.boss3hp
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthBar.value = boss3.boss3hp
	
	if boss3.laserEmitting:
		$ProgressBar/Panel.visible = false
	else:
		$ProgressBar/Panel.visible = true
	
	if healthBar.value <= 0:
		hide()
	else:
		show()
	pass
