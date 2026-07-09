extends Node2D
@onready var game = $".."
@onready var wheel = game.get_node("rouletteWheel")
@onready var fish: CharacterBody2D = $"../fish"

var iFrames = 0

var boss5maxhp = 450
var boss5hp = boss5maxhp
var passiveSpinSpeed = 0.7

var alive = true

var minAttack = 1
var maxAttack = 4


@onready var bluePokerChip = preload("res://scenes/objects/blue_poker_chip.tscn")
@onready var greenPokerChip = preload("res://scenes/objects/green_poker_chip.tscn")
@onready var diamond = preload("res://scenes/objects/diamond_attack.tscn")

signal spinFinish
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../rouletteWheel".spinSpeed = passiveSpinSpeed 
	
	globalSignals.connect("wheelFinish", func():
		spinFinish.emit())
	
	await get_tree().create_timer(2, false).timeout
	
	#await randomSpin()
	#await get_tree().create_timer(1.5, false).timeout
	
	while global.hp > 0 && boss5hp > 0:
		var rand = randi_range(minAttack, maxAttack)
		match rand:
			# phase 1
			1:
				await chipSpin()
			2:
				await diamondSpin()
			3:
				await diamondGen()
			4:
				await blueGreenMix()
				#phase 2
			5:
				await blueGreenMixDanger()
			6:
				await diamondGenAdv()
			7:
				await chipSpinAdv()
				#phase 3
			8:
				await diamondSpinAdv()
			9:
				await blueGreenMixAdv()
			10:
				await blueGreenMixDangerAdv()
		await global.timer(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	iFrames -= 60*delta
	if iFrames > 0:
		modulate.v = 0.7
	else:
		modulate.v = 1
	pass
	
	if boss5hp < boss5maxhp * 0.25:
		maxAttack = 10
		minAttack = 4
	elif boss5hp < boss5maxhp * 0.5:
		maxAttack = 10
		minAttack = 2
	elif boss5hp < boss5maxhp * 0.75:
		maxAttack = 7
		minAttack = 2
	if alive && boss5hp <= 0:
		bossDeath()
func reliefFlash():
	#$"../rouletteWheel/Sprite2D".show()
	#$"../rouletteWheel/Sprite2D/AnimationPlayer".play("flash")
	#await get_tree().create_timer(0.5, false).timeout
	#$"../rouletteWheel/Sprite2D".hide()
	pass



func readyWheel():
	if !$"../rouletteWheel".isReady:
		$"../rouletteWheel".spinSpeed = 0
		$"../rouletteWheel/AnimationPlayer".play("ready")
		$"../rouletteWheel".get_node("woodScrape").play()
		await get_tree().create_timer(0.5, false).timeout

func deReadyWheel():
	if $"../rouletteWheel".isReady:
		$"../rouletteWheel".spinSpeed = passiveSpinSpeed
		$"../rouletteWheel/AnimationPlayer".play("unready")
		$"../rouletteWheel".get_node("woodScrape").play()
		await get_tree().create_timer(0.5, false).timeout

func takeDamage(damage):
	iFrames = 10
	boss5hp -= damage
	
func bossDeath():
	alive = false
	var instance = game.fadeRect.instantiate()
	instance.type = true
	instance.superBright = true
	game.add_child(instance)
	globalSignals.emit_signal("boss5death")

# low level attacks

func randomSpin():
	await readyWheel()
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
	$"../Prompts/promptNoise".play()
		
	await spinFinish
	wheel.popIn()
	
	if rand == 5:
		wheel.flashBlack()
		wheel.flashRed()
		if game.inGreen && !game.inBlack && !game.inRed:
			reliefFlash()
		else:
			globalSignals.takeDmg.emit()
	elif rand % 2 == 0:
		wheel.flashBlack()
		wheel.flashGreen()
		if game.inRed && !game.inBlack && !game.inGreen:
			reliefFlash()
		else:
			globalSignals.takeDmg.emit()
	elif rand % 2 == 1:
		wheel.flashRed()
		wheel.flashGreen()
		if game.inBlack && !game.inRed && !game.inGreen:
			reliefFlash()
		else:
			globalSignals.takeDmg.emit()

func summonBlueChip(dual : bool):
	if !dual:
		await deReadyWheel()
	var instance = bluePokerChip.instantiate()
	instance.global_position = Vector2(randf_range(-1000, 17000), randf_range(0, 14000))
	game.add_child(instance)

func summonDiamond(dual : bool, advanced):
	if !dual:
		await deReadyWheel()
	var instance = diamond.instantiate()
	if advanced:
		instance.advanced = true
	game.add_child(instance)

func collectGreen(dual : bool, adv : bool):
	if !dual:
		await deReadyWheel()
	$"../Prompts/collectGreen".show()
	$"../Prompts/collectGreen/AnimationPlayer".play("splash")
	$"../Prompts/promptNoise".play()
	for i in range(5):
		var instance = greenPokerChip.instantiate()
		instance.global_position = Vector2(randf_range(4000, 10000), randf_range(9000, 12000))
		game.add_child(instance)
		if adv:
			await global.timer(randf_range(0.5, 1))
		else:
			await global.timer(1)
			
func dontCollectGreen(dual : bool, adv : bool):
	if !dual:
		await deReadyWheel()
	$"../Prompts/collectNothing".show()
	$"../Prompts/collectNothing/AnimationPlayer".play("splash")
	$"../Prompts/promptNoise".play()
	for i in range(5):
		var instance = greenPokerChip.instantiate()
		instance.global_position = Vector2(randf_range(2000, 12000), randf_range(9000, 12000))
		instance.dangerous = true
		game.add_child(instance)
		if adv:
			await global.timer(randf_range(0.5, 1))
		else:
			await global.timer(1)

# high level attacks
func chipSpin():
	randomSpin()
	for i in range (9):
		summonBlueChip(true)
		await global.timer(0.8)

func chipSpinAdv():
	randomSpin()
	for i in range (12):
		summonBlueChip(true)
		await global.timer(0.5)
	
func diamondSpin():
	randomSpin()
	for i in range(9):
		summonDiamond(true, false)
		await global.timer(0.8)
		
func diamondSpinAdv():
	randomSpin()
	for i in range(12):
		summonDiamond(true, false)
		await global.timer(0.5)
			
func diamondGen():
	for i in range(15):
		summonDiamond(false, false)
		await global.timer(0.4)
		
func diamondGenAdv():
	for i in range(15):
		summonDiamond(false, true)
		await global.timer(0.25)

func blueGreenMix():
	collectGreen(false, false)
	for i in range(9):
		summonBlueChip(false)
		await global.timer(0.6)
		
func blueGreenMixAdv():
	collectGreen(false, true)
	for i in range(11):
		summonBlueChip(false)
		await global.timer(randf_range(0.4, 0.5))
		
func blueGreenMixDanger():
	dontCollectGreen(false, false)
	for i in range(9):
		summonBlueChip(false)
		await global.timer(0.6)

func blueGreenMixDangerAdv():
	dontCollectGreen(false, true)
	for i in range(11):
		summonBlueChip(false)
		await global.timer(randf_range(0.4, 0.5))


func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.is_in_group("playerBullet")):
		if iFrames <= 0:
			takeDamage(global.shot_damage)
	if (area.is_in_group("playerSlash")):
		if iFrames <= 0:
			takeDamage(global.slash_damage)
			globalSignals.slashSuccess.emit()
	pass # Replace with function body.
