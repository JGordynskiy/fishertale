extends Node2D
@onready var region = get_node("/root/NavigationRegion2D")
@onready var fish = $"../fish"
@onready var game = $".."

@onready var damageParticles = load("res://scenes/particles/lightDamageParticles.tscn")

# Bound for random teleportation
@export var yRangeD : int
@export var yRangeU : int
@export var xRangeL : int
@export var xRangeR : int

@onready var sparkle = load("res://scenes/projectiles/sparkle.tscn")
@onready var sparkleLine = load("res://scenes/projectiles/sparkle_line_attack.tscn")
# distance from fish when randomly teleporting
var spawnMin = 4000
var spawnMax = 6000

var boss4hp = 200


var iFrames = 0
var rand = 0
var maxRand = 1

var dead = false
@onready var sprite: AnimatedSprite2D = $sprite

@onready var rng =  RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PointLight2D.energy = 0
	sprite.hide()
	
	rand = 0
	maxRand = 3
	
	# intro theatrics
	global_position = Vector2(34000, -34000)
	await global.timer(3)
	$chargePart.emitting = true
	await global.timer(1)
	spawnInLoc(global_position)
	await global.timer(2)
	spawnOut()
	await global.timer(1)
	
	while (boss4hp > 0 && global.hp > 0):
		await get_tree().create_timer(1, false).timeout
		spawnIn()
		if dead:
			break
		await get_tree().create_timer(2, false).timeout
		if dead:
			break
		spawnOut()
		if dead:
			break
			
		#choose next attack
		await attackSchedule()
		if dead:
			break

func takeDamage(damage):
	instDamageParticles()
	
	boss4hp -= damage *0.75
	
	#print_debug(boss4hp)
	
	rng.randomize()
	$SFX/dmgSFX.pitch_scale = randf_range(0.8, 1.2)
	$SFX/dmgSFX.play()
	iFrames = 10
	
func instDamageParticles():
	var instance = damageParticles.instantiate()
	instance.global_position = global_position
	instance.look_at(fish.global_position)
	instance.global_rotation += 0
	instance.emitting = true
	game.add_child(instance)
	
func attackSchedule():
	
	
	var oldRand = rand
	while (oldRand == rand):
		rng.randomize()
		rand = rng.randi_range(1, maxRand)
	
	bossScaling()
	
	#print_debug("attack: "+str(rand))
	if rand == 1:
		await basicTripWall()
	elif rand == 2:
		tripleSpiral()
	elif rand == 3:
		await barrageWall()
	elif rand == 4:
		await tripleWall()
	elif rand == 5:
		await cardinalSparkle()
		spinnySparkle(0)
	elif rand == 6:
		await target4Sparkle()
	elif rand == 7:
		trackingBarrage()
	
func bossScaling():
	if boss4hp <= 150:
		if boss4hp <= 100:
			if boss4hp <= 50:
				if boss4hp <= 25:
					if maxRand == 6:
						rand = 7
					maxRand = 7
				else:
					if maxRand == 5:
						rand = 6
					maxRand = 6
			else:
				if maxRand == 4:
						rand = 5
				maxRand = 5
		else:
			if maxRand == 3:
				rand = 4
			maxRand = 4
	else:
		if maxRand == 2:
			rand = 3
		maxRand = 3

func boss4death():
	globalSignals.boss4death.emit()
	
	sprite.show()
	$sprite/AnimationPlayer.play("RESET")
	
	$deathSFX.play()
	$deathPart.emitting = true
	dead = true
	$hitbox/CollisionPolygon2D.disabled = true
	await global.timer(0.2)
	$sprite.visible = true
	$sprite.play("dead")
	sprite.show()
	$sprite/AnimationPlayer.play("RESET")
	
	await global.timer(1)
	
	sprite.show()
	$sprite/AnimationPlayer.play("RESET")
	var tween = get_tree().create_tween()
	tween.tween_property($PointLight2D, "energy", 0, 2)
	
## spawn into a new location
func newLocation():
	var oldLoc = global_position
	var newLoc = global_position
	
	var count = 0
	
	## select a random location, keep going until the location is between 7000-10000 distance away from fish
	while(true):
		# looks cool when debugging lmao
		#await get_tree().process_frame 
		if (count > 10000):
			print_debug("failed.")
			break
		count += 1
		#print("Attempt "+str(count))
		#print(newLoc.distance_to(fish.global_position))
		rng.randomize()
		var rand1 = rng.randf_range(yRangeD, yRangeU)
		rng.randomize()
		var rand2 = rng.randi_range(xRangeL, xRangeR)
		newLoc = Vector2(rand2, rand1)
		
		if (oldLoc.distance_to(newLoc) > 2000 && newLoc.distance_to(fish.global_position) > spawnMin && newLoc.distance_to(fish.global_position) < spawnMax):
			break
			
	#print("===Final distance: "+str(global_position.distance_to(fish.global_position)))
	global_position = newLoc

func spawnIn():
	turnOnLight()
	await newLocation()
	sprite.play("spawnIn")
	$sprite/AnimationPlayer.play("spawnIn")
	await get_tree().create_timer(0.01, false).timeout
	$SFX/spawnSFX.play()
	sprite.show()
	$spawn.restart()
	$spawn.emitting = true
	
	await get_tree().create_timer(0.5, false).timeout
	$hitbox/CollisionPolygon2D.disabled = false
	sprite.play("idle")
	pass
	
func spawnInLoc(location):
	turnOnLight()
	global_position = location
	sprite.play("spawnIn")
	$sprite/AnimationPlayer.play("spawnIn")
	await get_tree().create_timer(0.01, false).timeout
	
	$SFX/spawnSFX.play()
	sprite.show()
	$spawn.restart()
	$spawn.emitting = true
	
	await get_tree().create_timer(0.5, false).timeout
	$hitbox/CollisionPolygon2D.disabled = false
	sprite.play("idle")
	pass

func spawnOut():
	if dead:
		return
	
	turnOffLight()
	sprite.play("spawnOut")
	$sprite/AnimationPlayer.play("spawnOut")
	await get_tree().create_timer(0.1, false).timeout
	
	$SFX/despawnSFX.play()
	$hitbox/CollisionPolygon2D.disabled = true
	sprite.hide()
	$spawn.restart()
	$spawn.emitting = true
	pass

func turnOffLight():
	var tween = get_tree().create_tween()
	tween.tween_property($PointLight2D, "energy", 0, 0.2)
	
func turnOnLight():
	var tween = get_tree().create_tween()
	tween.tween_property($PointLight2D, "energy", 0.8, 0.2)
	
# Lower level attacks

func oneLine(pos, rot):
	var instance = sparkleLine.instantiate()
	instance.global_position = pos
	instance.global_rotation = rot
	game.add_child(instance)

func manyLinesHori(density):
	rng.randomize()
	
	var initialY = fish.global_position.y + rng.randf_range(-(density), density)
	
	var pos = Vector2(xRangeL - 1500, initialY)
	for i in range(6):
		oneLine(Vector2(pos.x, pos.y -(density*i)), 0)
		
	pos = Vector2(xRangeL - 1500, initialY)
	for i in range(6):
		oneLine(Vector2(pos.x, pos.y +(density*i)), 0)
	
func manyLinesVert(density):
	rng.randomize()
	
	var initialX = fish.global_position.x + rng.randf_range(-(density), density)
	
	var pos = Vector2(initialX, yRangeU+1500)
	for i in range(8):
		oneLine(Vector2(pos.x - (density*i), pos.y ), -(PI/2))
		
	pos = Vector2(initialX, yRangeU+1500)
	for i in range(8):
		oneLine(Vector2(pos.x + (density*i), pos.y ), -(PI/2))
		
func manyLinesDiag(density):
	rng.randomize()
	var fishDistFromBottom = yRangeU - fish.global_position.y
	var pos = Vector2(fish.global_position.x - fishDistFromBottom, yRangeU+1500)
	
	var initialX = pos.x + rng.randf_range(-(density*4), density*4)
	for i in range(10):
		oneLine(Vector2(initialX + (density*i*1.5), pos.y), PI/4*-1)
	for i in range(10):
		oneLine(Vector2(initialX - (density*i*1.5), pos.y), PI/4*-1)

func manyLinesDiag2(density):
	rng.randomize()
	var fishDistFromBottom = yRangeU - fish.global_position.y
	var pos = Vector2(fish.global_position.x + fishDistFromBottom, yRangeU+1500)
	
	var initialX = pos.x + rng.randf_range(-(density*4), density*4)
	for i in range(10):
		oneLine(Vector2(initialX + (density*i*1.5), pos.y), 3*PI/4*-1)
	for i in range(10):
		oneLine(Vector2(initialX - (density*i*1.5), pos.y), 3*PI/4*-1)

func spinnySparkle(dir):
	var instance = sparkle.instantiate()
	instance.global_position = global_position
	instance.dir = dir
	instance.type = 0
	instance.speed = 8000
	game.add_child(instance)

func basicSparkle(dir, speed):
	var instance = sparkle.instantiate()
	instance.global_position = global_position
	instance.dir = dir
	instance.type = 2
	instance.speed = speed
	game.add_child(instance)

func trackLine():
	rng.randomize()
	
	@warning_ignore("shadowed_variable")
	var rand = randi_range(1, 4)
	var pos : Vector2
	if rand == 1:
		pos = Vector2(rng.randf_range(xRangeL, xRangeR), yRangeU + 1500) # on bottom, anywhere X
	elif rand == 2:
		pos = Vector2(xRangeR+1500, rng.randf_range(yRangeU, yRangeD)) # on right, anywhere y
	elif rand == 3:
		pos = Vector2(rng.randf_range(xRangeL, xRangeR), yRangeD - 1500) # on top, anywhere x
	elif rand == 4:
		pos = Vector2(xRangeL-1500, rng.randf_range(yRangeU, yRangeD)) # on left, anywhere y
		
	var dir = pos.angle_to_point(fish.global_position)
	dir += rng.randf_range(-0.06, 0.06)
	oneLine(pos, dir)
		


# High Level attacks
## 1 Spiral sparkle, 3 shrinking linewalls
func spiralWall():
	rng.randomize()
	spinnySparkle(randf_range(0, PI))
	manyLinesHori(2700)
	await get_tree().create_timer(0.7, false).timeout
	manyLinesVert(2400)
	await get_tree().create_timer(0.7, false).timeout
	manyLinesHori(2000)
	await get_tree().create_timer(0.7, false).timeout

## 3 linewalls, single diection
func basicTripWall():
	manyLinesHori(2200)
	await global.timer(0.8)
	manyLinesVert(2000)
	await global.timer(0.8)
	manyLinesHori(1800)

## 3 spiral sparkles
func tripleSpiral():
	rng.randomize()
	var rot = randf_range(0, 2*PI)
	
	for i in range(3):
		spinnySparkle(rot +(i*PI/4))

## five sets of linewalls with varying direction and shrinking density
func barrageWall():
	manyLinesHori(2300)
	await get_tree().create_timer(0.7, false).timeout
	manyLinesVert(2200)
	await get_tree().create_timer(0.7, false).timeout
	manyLinesDiag(1900)
	await get_tree().create_timer(0.7, false).timeout
	manyLinesHori(1600)
	await get_tree().create_timer(0.7, false).timeout
	manyLinesDiag2(1600)
	await get_tree().create_timer(0.7, false).timeout

## Three sets of double linewalls
func tripleWall():
	manyLinesHori(2400)
	manyLinesVert(2400)
	await global.timer(1.0)
	manyLinesDiag(2000)
	manyLinesDiag2(2000)
	await global.timer(1.0)
	manyLinesHori(1600)
	manyLinesVert(1600)

## 8 basic sparkles 45 degree difference
func cardinalSparkle():
	var startDir = rng.randf_range(0, PI)
	$chargePart.emitting = true
	$xtraLight.energy = 1
	await global.timer(0.9)
	$xtraLight.energy = 0
	for i in range(8):
		basicSparkle((PI*i)/4 + startDir, 12000)

## 8 basic sparkles random directions
func random8Sparkle():
	for i in range(8):
		basicSparkle(rng.randf_range(0, 2*PI), 10000)
		rng.randomize()

## 4 basic sparkles targets to fish accompanied by 10 tracking lines
func target4Sparkle():
	$chargePart.emitting = true
	$xtraLight.energy = 1
	await global.timer(1)
	$xtraLight.energy = 0
	$spawn.restart()	
	$spawn.emitting = true
	
	var dir = global_position.angle_to_point(fish.global_position) - PI/4
	for i in range(4):
		basicSparkle(dir + i*(PI/8), 10000)
		rng.randomize()
		
	#await global.timer(0.5)
	
	for i in range(8):
		trackLine()
		await global.timer(0.2)
	await global.timer(0.5)
	
## 20 fast tracking lines
func trackingBarrage():
	#spinnySparkle(0)
	for i in range(20):
		trackLine()
		await global.timer(0.1)




# Physics process
func _physics_process(delta: float) -> void:
	iFrames -= 120*delta
	if iFrames > 0:
		modulate.v = 0.8
	else:
		modulate.v = 1
	pass
	if boss4hp <= 0 && !dead:
		boss4death()
	if dead:
		sprite.show()
		sprite.play("dead")
		$sprite/AnimationPlayer.play("RESET")


# take damage + collision
func _on_hitbox_area_entered(area: Area2D) -> void:
	if (area.is_in_group("playerBullet")):
		if iFrames <= 0:
			takeDamage(global.shot_damage)
	if (area.is_in_group("playerSlash")):
		if iFrames <= 0:
			takeDamage(global.slash_damage)
			globalSignals.slashSuccess.emit()
	pass # Replace with function body.
