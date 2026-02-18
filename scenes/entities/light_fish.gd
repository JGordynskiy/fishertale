extends Node2D
@onready var region = get_node("/root/NavigationRegion2D")
@onready var fish = $"../fish"

@export var yRangeD : int
@export var yRangeU : int
@export var xRangeL : int
@export var xRangeR : int

var spawnMin = 5000
var spawnMax = 9000

@onready var sprite: AnimatedSprite2D = $sprite

@onready var rng =  RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.hide()
	
	await get_tree().create_timer(1, false).timeout
	
	for i in range(30):
		spawnIn()
		await get_tree().create_timer(2, false).timeout
		spawnOut()
		await get_tree().create_timer(2, false).timeout
		
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
	
## spawn into a new location
func spawnIn():
	
	await newLocation()
	sprite.play("spawnIn")
	$sprite/AnimationPlayer.play("spawnIn")
	await get_tree().create_timer(0.01, false).timeout
	
	sprite.show()
	$spawn.restart()
	$spawn.emitting = true
	
	await get_tree().create_timer(0.5, false).timeout
	$hitbox/CollisionShape2D.disabled = false
	sprite.play("idle")
	pass
	
	
func spawnInLoc(location):
	
	global_position = location
	sprite.play("spawnIn")
	$sprite/AnimationPlayer.play("spawnIn")
	await get_tree().create_timer(0.01, false).timeout
	
	sprite.show()
	$spawn.restart()
	$spawn.emitting = true
	
	await get_tree().create_timer(0.5, false).timeout
	$hitbox/CollisionShape2D.disabled = false
	sprite.play("idle")
	pass

func spawnOut():
	sprite.play("spawnOut")
	$sprite/AnimationPlayer.play("spawnOut")
	await get_tree().create_timer(0.1, false).timeout
	
	$hitbox/CollisionShape2D.disabled = true
	sprite.hide()
	$spawn.restart()
	$spawn.emitting = true
	pass
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
