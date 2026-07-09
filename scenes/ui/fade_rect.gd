extends CanvasLayer
var type : bool

var superBright = false

# True means opacity goes to 100 (exiting scene)
# False means opacity goes to 0 (entering scene)
@onready var animation_player: AnimationPlayer = $faderect/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if superBright:
		$faderect.color = Color(1, 1, 1, 1)
	if (type):
		$faderect.self_modulate.a = 0
		animation_player.play("fadein")
	if (!type):
		animation_player.play("fadeout")
		pass
	await get_tree().create_timer(2, false).timeout
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
