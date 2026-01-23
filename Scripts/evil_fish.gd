extends CharacterBody2D

@onready var game = get_owner()
@onready var fish = game.get_node("fish") 
@onready var bullet = load("res://scenes/enemy_bullet.tscn")
@onready var superbullet = load("res://scenes/super_bullet.tscn")
@onready var dashParticle = load("res://scenes/particles/evilFishParticles.tscn")
@onready var dash2Particle = load("res://scenes/particles/evilFishChargeParticle.tscn")
@onready var deathParticle = load("res://scenes/particles/evilFishdeathParticles.tscn")
@onready var mini_charge: GPUParticles2D = $miniCharge
@onready var recoil: AnimationPlayer = $Sprite2D/recoil
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var total_fade: AnimationPlayer = $totalFade


var boss1hp = 100
var coolDown = 0
var coolMult = 1
var startTimer : int

var moveSpeedSet = 2500
var moveSpeed : float
var speed = 0

var anger = 0

@onready var navAgent: NavigationAgent2D = $NavigationAgent2D

var dashing = false
var rng = RandomNumberGenerator.new()
var iFrames = 0
var randInt = 0
var pathPos :Vector2
# Called when the node enters the scene tree for the first time.
signal boss1death
var dead = false

func _ready() -> void:
	startTimer = 150
	moveSpeed = 0
	coolMult = 1
	
	dead = false
	$Dead.hide()
	dashing = false
	pathPos = navAgent.get_next_path_position()
	coolDown = 0
	speed = moveSpeed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	@warning_ignore("narrowing_conversion")
	startTimer -= 10*delta
	
	if boss1hp< 1:
		$Dead.show()
		$Sprite2D.hide()
		if !dead:
			dead = true
			globalSignals.emit_signal("boss1death")
			$deathSFX.play()
			var instance = deathParticle.instantiate()
			add_child(instance)
			
			await get_tree().create_timer(4, false).timeout
			total_fade.play("fadeaway")
	#faster attacks the lower HP
	if boss1hp < 75 && boss1hp > 50:
		coolMult = 0.95
		
	if boss1hp < 50 && boss1hp > 25:
		coolMult = 0.9
	if boss1hp < 25:
		coolMult = 0.8
	
	#SlowDash
	if (moveSpeed > 0 && !dashing):
		moveSpeed -= 10000*delta
		pass
	
	
	##forces the fish to look at the player as long as it's alive
	if (boss1hp > 0):
		look_at(fish.global_position)
		
	# ATTACK SCHEDULE
	#
	#
	if coolDown < 0 && boss1hp>0 && global.hp > 0 && startTimer < 1:
		randInt = rng.randi_range(1,8)
		if randInt == 1 || randInt == 2:
			look_at(fish.global_position)
			burst()
		if randInt == 3 || randInt == 4 :
			look_at(fish.global_position)
			triAttack()
		if randInt == 5 ||randInt == 6 || randInt == 7:
			dash(delta)
		if randInt == 8:
			look_at(fish.global_position)
			superBullet()
	coolDown -= 50*delta
	
	iFrames -= 60*delta
	
	#Color for taking damage
	if iFrames < 0:
		$Sprite2D.self_modulate.s = 0
	
	#Upright
	if rotation < -1*(PI/2) || rotation > PI/2:
		$Sprite2D.flip_v = true
	else:
		$Sprite2D.flip_v = false
	#Navigation
	
	if boss1hp > 0 && global.hp>0 && coolDown < 400:
		pathPos = navAgent.get_next_path_position()
		var dir = (pathPos - global_position).normalized()
		velocity = dir*speed
	else:
		velocity = Vector2(0,0)
		
	speed = moveSpeed
	move_and_slide()
	
func makePath():
	
	
	if navAgent.distance_to_target() > 13000:
		speed = moveSpeed *3
	#elif navAgent.distance_to_target() > 10000:
		#speed = moveSpeed *2
	#elif navAgent.distance_to_target() > 6000:
		#speed = moveSpeed *1.5
	else:
		speed = moveSpeed
	navAgent.target_position = fish.global_position
		
	
	
	
func dash(delta):
	if dashing:
		return
	$chargeup.play()
	var instance = dashParticle.instantiate()
	#instance.global_position = global_position

	add_child(instance)
	moveSpeed = 0
	coolDown = 130*coolMult
	dashing = true
	var orgSpeed = moveSpeedSet
	#moveSpeed = 0
	
	await get_tree().create_timer(1, false).timeout
	$chargeSFX.play()
	rng.randomize()
	makePath()
	moveSpeed = orgSpeed *rng.randf_range(4,6)
	
	await get_tree().create_timer(0.4, false).timeout

	dashing = false
	

	
	
func superBullet():
	coolDown = 100*coolMult
	#mini_charge.emitting = true
	#await get_tree().create_timer(0.3, false)
	var pinstance = dash2Particle.instantiate()
	add_child(pinstance)
	
	await get_tree().create_timer(0.5, false).timeout
	if (boss1hp < 1):
		return
	var instance = superbullet.instantiate()
	recoil.play("recoil")
	instance.range = 9999
	instance.spawnPos = global_position
	instance.spawnRot = global_rotation
	instance.dir = global_rotation
	instance.shotspeed = 15000
	game.add_child(instance)
	
	
func shoot(rot):
	var instance = bullet.instantiate()
	instance.range = 1500
	instance.spawnPos = global_position
	instance.spawnRot = global_rotation +rot+PI
	instance.dir = global_rotation + rot+PI
	instance.shotspeed = 15000
	
	game.add_child(instance)
	
func triAttack():
	
	coolDown = 90*coolMult
	mini_charge.emitting = true
	await get_tree().create_timer(0.5, false).timeout
	if (boss1hp < 1):
		return
	recoil.play("recoil")
	shoot(-PI/8)
	shoot(0)
	shoot(PI/8)
	
	pass
	


func burst():
	coolDown = 65*coolMult
	mini_charge.emitting = true
	await get_tree().create_timer(0.5, false).timeout
	if (boss1hp < 1):
		return
	for i in range (3):
		if (boss1hp < 1):
			return
		recoil.play("recoil")
		shoot(randf_range(-0.1,0.1))
		await get_tree().create_timer(0.1).timeout
	
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("playerBullet"):
		if iFrames < 0 && boss1hp > 0:
			boss1hp -= global.shot_damage
			iFrames = 10
			$Sprite2D.self_modulate.s = 0.5
	if area.is_in_group("playerSlash"):
		if iFrames < 0 && boss1hp > 0:
			boss1hp -= global.slash_damage
			iFrames = 10
			$Sprite2D.self_modulate.s = 0.5
			globalSignals.slashSuccess.emit()
		
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	makePath()
	pass # Replace with function body.




func _on_navigation_agent_2d_navigation_finished() -> void:
	navAgent.target_position = fish.global_position
	
	pass # Replace with function body.


func _on_navigation_agent_2d_link_reached(_details: Dictionary) -> void:
	if !dashing:
		navAgent.target_position = fish.global_position
	pass # Replace with function body.
