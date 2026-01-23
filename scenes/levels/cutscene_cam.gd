extends Camera2D
@onready var followCam: Camera2D = $"../fish/followCam"
@onready var boss1img: Sprite2D = $TextureRect/boss1Img


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globalSignals.connect("game1toR", transitionCutscene)
	enabled = false
	pass # Replace with function body.
	
	

func transitionCutscene():
	enabled = true
	global_position = followCam.global_position
	scale.x = followCam.scale.x
	scale.y = followCam.scale.y
	zoom.x = 0.06
	zoom.y = 0.06
	var tween = create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", global.whirlPoolPos, 1.5)
	tween.tween_property(self, "zoom", Vector2(0.15,0.15), 1.5)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
