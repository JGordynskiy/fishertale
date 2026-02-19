extends Camera2D

var cent = get_viewport_rect().size / 2.0
var pos2
var target
var max_dist
var theOffset
var theOffset2
var maxCamDist = 3000

var tutorial = false
var tutStage = 0

var rng = RandomNumberGenerator.new()
@onready var fish: CharacterBody2D = $".."
var rotLock = true

@onready var dmgSplash = load("res://scenes/damage_splash.tscn")

#@onready var fish = root_level.get_node("fish")


const MAX_ZOOM = 0.05
const MIN_ZOOM = 0.12
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enabled = true
	
	globalSignals.gameOver.connect(deathZoom)
	
	pass # Replace with function body.

func disableCam():
	enabled = false
	


## Shakes the camera. (Intensity 0-3, length 5-20)
func shake(intensity, length):
	for i in range(length):
		rng.randomize()
		offset.x = randf_range(-300*settings.camShake*intensity, 300*settings.camShake*intensity)
		rng.randomize()
		offset.y = randf_range(-300*settings.camShake*intensity, 300*settings.camShake*intensity)
		await get_tree().create_timer(0.01, true).timeout
	offset.x = 0
	offset.y = 0
	
func takeDamage():
	var instance = dmgSplash.instantiate()
	var game = get_tree().get_current_scene()
	game.add_child.call_deferred(instance)
	
	if tutStage < 3 && tutorial:
		global.hp +=1
	shake(1, 10)
	
	
func deathZoom():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(0.1,0.1), 1.5).set_trans(Tween.TRANS_CUBIC)
	pass
	
#TUTORIAL ONLY
func tutorialCutscene():
	if tutorial:
		if tutStage == 0:
			limit_left = -33720
			limit_top = -25705
			limit_right = -13000
			limit_bottom = -8030
		if tutStage == 1:
			limit_left = -28720
			limit_top = -25705
			limit_right = -2220
			limit_bottom = -8030
		if tutStage == 2:
			limit_left = -28720
			limit_top = -25705
			limit_right = 12230
			limit_bottom = -5915
		if tutStage == 3:
			limit_left = -10715
			limit_top = -20600
			limit_right =11545 
			limit_bottom = 7520
		if tutStage == 4:
			limit_left = -36855
			limit_top = -6660
			limit_right =11545 
			limit_bottom = 15545

# Called every frame. 'delta' is the eSlapsed time since the previous frame.
func _process(delta: float) -> void:
	#TUTORIAL ONLY
	tutorialCutscene()
	
	if rotLock:
		global_rotation = 0
	

	
	# moves the camera according to the mouse
	if global.hp > 0:
		target = (fish.global_position + get_global_mouse_position()) / 2
		theOffset = target - fish.global_position
		theOffset2 = theOffset
		if (theOffset2.x > maxCamDist*2):
			theOffset2.x = maxCamDist*2
		if (theOffset2.x < maxCamDist*-2):
			theOffset2.x = maxCamDist*-2
		if (theOffset2.y > maxCamDist):
			theOffset2.y = maxCamDist
		if (theOffset2.y < -0.25*maxCamDist):
			theOffset2.y = -0.25*maxCamDist
		#print("Updating camera!")
		global_position = (fish.global_position+theOffset2)
	else:
		#print("not updating camera!")
		global_position = fish.global_position
	pass
