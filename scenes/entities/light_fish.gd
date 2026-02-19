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

var iFrames = 0
@onready var sprite: AnimatedSprite2D = $sprite

@onready var rng =  RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.hide()
	
	
	
	for i in range(30):
		await get_tree().create_timer(1, false).timeout
		spawnIn()
		await get_tree().create_timer(2, false).timeout
		spawnOut()
		
		manyLinesHori(2000)
		await get_tree().create_timer(0.5, false).timeout
		manyLinesVert(2000)
		await get_tree().create_timer(0.5, false).timeout
		manyLinesHori(2000)
		await get_tree().create_timer(0.5, false).timeout
		
	pass # Replace with function body.



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

func takeDamage(damage):
	instDamageParticles()
	
	rng.randomize()
	$SFX/dmgSFX.pitch_scale = randf_range(0.8, 1.2)
	$SFX/dmgSFX.play()
	iFrames = 10
	
func instDamageParticles():
	var instance = damageParticles.instantiate()
	instance.global_position = global_position
	instance.look_at(fish.global_position)
	instance.global_rotation += PI
	instance.emitting = true
	game.add_child(instance)
	
	
## spawn into a new location
func spawnIn():
	
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
	sprite.play("spawnOut")
	$sprite/AnimationPlayer.play("spawnOut")
	await get_tree().create_timer(0.1, false).timeout
	
	$SFX/despawnSFX.play()
	$hitbox/CollisionPolygon2D.disabled = true
	sprite.hide()
	$spawn.restart()
	$spawn.emitting = true
	pass
	
func _process(delta: float) -> void:
	iFrames -= 120*delta
	if iFrames > 0:
		modulate.v = 0.8
	else:
		modulate.v = 1
	pass

# attacks

func oneLine(pos, rot):
	var instance = sparkleLine.instantiate()
	instance.global_position = pos
	instance.global_rotation = rot
	game.add_child(instance)

func manyLinesHori(density):
	rng.randomize()
	var pos = Vector2(xRangeL - 1500, yRangeU+1500)
	pos.y += rng.randf_range(-(density), density)
	for i in range(30):
		oneLine(Vector2(pos.x, pos.y -(density*i)), 0)

func manyLinesVert(density):
	rng.randomize()
	var pos = Vector2(xRangeL-1500, yRangeU+1500)
	pos.x += rng.randf_range(-(density), density)
	for i in range(30):
		oneLine(Vector2(pos.x + (density*i), pos.y), PI/2*-1)

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
