extends Node2D

@onready var fish = get_node("../../fish") 
@onready var eBullet = load("res://scenes/enemy_bullet.tscn")
@onready var game = get_tree().root
var cannonShooting = true
var shootTime = 1.0
var coolingDown = false
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

func shoot(acc):
	var instance = eBullet.instantiate()
	var rand = rng.randf_range(-acc,acc)
	instance.range = 1500
	instance.spawnPos = global_position
	instance.spawnRot = global_rotation + rand
	instance.dir = global_rotation + rand
	instance.shotspeed = 12000
		
	game.add_child.call_deferred(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print (modulate.s)
	#if modulate.s > 0:
		#modulate.s -= 50*delta
	
	if Input.is_action_just_pressed("DEBUGcannonshoot"):
		#print(cannonShooting)
		#cannonShooting = !cannonShooting
		#if cannonShooting:
			#modulate.a = 1
		#else:
			#modulate.a = 0.25
		shoot(0)
		
	if cannonShooting:
		global_rotation = global_position.angle_to_point(fish.global_position) + PI
		#look_at(fish.global_position)
	#if(cannonShooting && !coolingDown):
		#
		#
		#shoot(0)
		#shoot(0.5)
		#if shootTime < 0.1:
			#shootTime = 1
		#shootTime -=0.05
		#coolingDown = true
		#await get_tree().create_timer(shootTime).timeout
		#coolingDown = false
		
	pass



func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.is_in_group("playerBullet")):
		print("cannonhit!")
		#modulate.s = 100
	pass # Replace with function body.
