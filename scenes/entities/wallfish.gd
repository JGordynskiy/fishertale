extends CharacterBody2D
@onready var fan: Node2D = $"../fan"

var iFrames = 0.0
var boss2hp = 100
var rng = RandomNumberGenerator.new()

var active = false 
var cooldown = 120

@onready var game2: Node2D = $".."

@onready var bullet = load("res://scenes/enemy_bullet.tscn")
@onready var rock = load("res://scenes/objects/rockattack.tscn")
@onready var fish = get_node("../fish")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globalSignals.boss2Start.connect(summon)
	pass 



func _process(delta: float) -> void:
	if global.hp > 0:
		attackSchedule(delta)
	
	
	
	iFrames -= 120*delta
	if iFrames > 0:
		modulate.v = 0.5
	else:
		modulate.v = 1
	
	#Adjust fan speed based on boss health
	if boss2hp > 70:
		game2.fanSpeed = 30
	if boss2hp <= 70 && boss2hp > 40:
		game2.fanSpeed = 45
	if boss2hp <= 40 && boss2hp > 10:
		game2.fanSpeed = 60
	if boss2hp <= 10 && boss2hp > 0:
		game2.fanSpeed = 75
	if boss2hp <= 0 && boss2hp > -99:
		
		boss2hp = -100
		globalSignals.emit_signal("boss2death")
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", Vector2(25541.0, -20737.0), 3)
		active = false
		$deathSFX.play()
		$deathParticles.emitting = true
		
	pass
	
func attackSchedule(delta):
	if active:
		cooldown -= 60*delta
		if cooldown < 0:
			cooldown = 120
			rng.randomize()
			var rand = randi_range(1, 3)
			if (rand == 1 || rand == 2):
				for i in range(3):
					rockAttack()
					await get_tree().create_timer(0.3, false).timeout
				cooldown += 20
			else:
				for i in range(3):
					bulletAttack()
					await get_tree().create_timer(0.2, false).timeout
				cooldown -= 30
		
	

func summon():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(16541.0, -20737.0), 3)
	active = true
	cooldown = 180

func bulletAttack():
	var instance = bullet.instantiate()
	instance.z_index = 200
	rng.randomize()
	
	
	
	instance.range = 1500
	rng.randomize()
	instance.spawnPos = Vector2(global_position.x, global_position.y +randf_range(-5000, 5000))
	var rot = instance.spawnPos.angle_to_point(fish.global_position)+PI
	
	
	
	instance.spawnRot = rot
	instance.dir = rot
	instance.shotspeed = 10000
	
	
	game2.add_child(instance)
	
	
func rockAttack():
	var instance = rock.instantiate()
	instance.startx = -5500
	instance.endx = 30000
	instance.yrange1 = fish.global_position.y - 4000
	instance.yrange2 = fish.global_position.y + 4000
	
	game2.add_child(instance)
	pass
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("playerBullet"):
		if iFrames < 0:
			iFrames = 30
			boss2hp -= global.shot_damage
			
	if area.is_in_group("playerSlash"):
		if iFrames < 0:
			iFrames = 30
			boss2hp -= global.slash_damage
			globalSignals.slashSuccess.emit()
			
	pass # Replace with function body.
