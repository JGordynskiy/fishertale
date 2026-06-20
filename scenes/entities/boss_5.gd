extends Node2D
@onready var game = get_tree().current_scene
@onready var wheel = game.get_node("rouletteWheel")
@onready var fish: CharacterBody2D = $"../fish"
signal spinFinish
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globalSignals.connect("wheelFinish", func():
		spinFinish.emit())
	
	await get_tree().create_timer(2, false).timeout
	
	while true:
		await randomSpin()
		await get_tree().create_timer(1.5, false).timeout
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reliefFlash():
	$"../rouletteWheel/Sprite2D".show()
	$"../rouletteWheel/Sprite2D/AnimationPlayer".play("flash")
	await get_tree().create_timer(0.5, false).timeout
	$"../rouletteWheel/Sprite2D".hide()

func randomSpin():
	$"../Prompts/betOnRed".hide()
	$"../Prompts/betOnBlack".hide()
	$"../Prompts/betOnGreen".hide()
	var rand = randi_range(1, 5)
	
	wheel.popOut()
	await get_tree().create_timer(0.5, false).timeout
	wheel.spin()
	
	if rand == 5:
		$"../Prompts/betOnGreen".show()
		$"../Prompts/betOnGreen/AnimationPlayer".play("splash")
	elif rand % 2 == 0:
		$"../Prompts/betOnRed".show()
		$"../Prompts/betOnRed/AnimationPlayer".play("splash")
	elif rand % 2 == 1:
		$"../Prompts/betOnBlack".show()
		$"../Prompts/betOnBlack/AnimationPlayer".play("splash")
		
	await spinFinish
	wheel.popIn()
	
	if rand == 5:
		if game.inGreen && !game.inBlack && !game.inRed:
			reliefFlash()
		else:
			globalSignals.takeDmg.emit()
	elif rand % 2 == 0:
		if game.inRed && !game.inBlack && !game.inGreen:
			reliefFlash()
		else:
			globalSignals.takeDmg.emit()
	elif rand % 2 == 1:
		if game.inBlack && !game.inRed && !game.inGreen:
			reliefFlash()
		else:
			globalSignals.takeDmg.emit()
	
	
