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
	
	if boss3.invulnerable && boss3.boss3hp>0:
		$ProgressBar/Panel.visible = true
	else:
		$ProgressBar/Panel.visible = false
	
	if healthBar.value <= 0:
		hide()
	else:
		show()
	pass
