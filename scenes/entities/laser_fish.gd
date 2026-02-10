extends CharacterBody2D

@onready var bullet = load("res://scenes/enemy_bullet.tscn")

@onready var fishRay: RayCast2D = $fishDetector
@onready var laserRay: RayCast2D = $laserRay
@onready var laser: Line2D = $laser
@onready var fish = get_node("../fish")
@onready var game = get_node("..")
var rng = RandomNumberGenerator.new()

@onready var navAgent: NavigationAgent2D = $NavigationAgent2D

var dead = false

var laserEmitting = false
var turreting = false

var iFrames = 0
var coolDown = 300
var boss3hp = 100
var moveSpeed = 7500
var speed = 0


var pathPos : Vector2

func _ready() -> void:
	$alive.visible = true
	$dead.visible = false
	##Shoots laser twice, then begins normal attacks
	#laser.visible = false
	#await get_tree().create_timer(1, false).timeout
	#sweepLaser()
	#coolDown = 999
	#await get_tree().create_timer(4, false).timeout
	#sweepLaser()
	coolDown = 25
	pass 

func _physics_process(delta: float) -> void:
	#setting the laser
	var laserLength = global_position.distance_to(laserRay.get_collision_point())
	laser.points = PackedVector2Array([Vector2(0, 0), Vector2(laserLength/28*-1, 0)])
	
	
	iFrames -= 60*delta
	coolDown -= 30*delta

	#invulernability frames
	if iFrames > 0:
		modulate.v = 0.5
	else:
		modulate.v = 1
	pass
	
	# take Damage from laser
	if $fishDetector.get_collider() != null:
		if $fishDetector.get_collider().is_in_group("player") && laserEmitting:
			globalSignals.takeDmg.emit()
	
	#invulnerability Visual
	if !laserEmitting && boss3hp > 0:
		$invulenrablePolygon.visible = true
	else:
		$invulenrablePolygon.visible = false
	
	#Navigation + movement
	if (boss3hp > 0 && global.hp > 0):
		pathPos = navAgent.get_next_path_position()
		var dir = (pathPos - global_position).normalized()
		velocity = dir*speed

	#align fishfinder (check if in line of sight)
	$fishFinder.global_rotation = $fishFinder.global_position.angle_to_point(fish.global_position)
	
	#attack schedule
	rng.randomize()
	var rand = rng.randi_range(1, 4)
	
	if coolDown < 0:
		if global.hp > 0 && boss3hp > 0:
			if ($fishFinder.get_collider().is_in_group("player")):
				attackSchedule()
			else:
				follow()


	if (speed > 0):
		speed -= 3500*delta
		global_rotation = global_position.angle_to_point(fish.global_position) + PI
	move_and_slide()
	
func shoot(rot):
	var instance = bullet.instantiate()
	instance.range = 1500
	instance.spawnPos = global_position
	instance.spawnRot = global_rotation +rot+PI
	instance.dir = global_rotation + rot+PI
	instance.shotspeed = 11000
	instance.z_index = 200
	game.add_child(instance)
	pass

func follow():
	coolDown = 50
	makePath()
	speed = moveSpeed

func makePath():
	navAgent.target_position = fish.global_position

func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	if (boss3hp <= 0):
		return
	if area.is_in_group("playerBullet"):
		if iFrames < 0 && laserEmitting:
			iFrames = 10
			boss3hp -= global.shot_damage
		elif !laserEmitting:
			shoot(area.global_rotation-global_rotation+(PI/2))
			
	if area.is_in_group("playerSlash"):
		if iFrames < 0 && laserEmitting:
			globalSignals.slashSuccess.emit()
			iFrames = 10
			boss3hp -= global.slash_damage
		elif !laserEmitting:
			shoot(area.global_rotation-global_rotation+(PI))
	if boss3hp <= 0:
			boss3death()
	pass 

func attackSchedule():
	rng.randomize()
	var rando = rng.randi_range(1,8)
	match rando:
		1:
			sweepLaser()
		2:
			sweepLaser()
		3:
			sweepLaser()
		4:
			sweepLaser()
		5:
			$"../enemies/laserTurret".shoot()
		6:
			$"../enemies/laserTurret2".shoot()
		7:
			$"../enemies/laserTurret3".shoot()
		8:
			$"../enemies/laserTurret4".shoot()
	pass
	
func sweepLaser():
	coolDown = 100
	#speed = 0
	$laserTelegraph.emitting = false
	rng.randomize()
	var sweepRange = randf_range(0.4, 0.8)
	var parity = 0
	while (parity == 0):
		rng.randomize()
		parity = randi_range(-1, 1)
	if dead:
		return
	$laser.visible = false
	$laser.modulate.a = 1
	$laser/AnimationPlayer.play("RESET")
	#orients laser fish correctly
	var tween = create_tween()
	tween.tween_property(self, "global_rotation", global_position.angle_to_point(fish.global_position) + PI - sweepRange*parity, 0.5).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(0.5, false).timeout #time from rotation to telegraph
	
	#telegraphing the laser
	$laserTelegraph.restart()
	$laserTelegraph.emitting = true
	$laserCharge.play()
	if dead:
		return
	# setting the laser correctly!
	
	
	await get_tree().create_timer(1, false).timeout #telegraph time
	
	#Actually start the laser
	$laser/AnimationPlayer.play("laserIn")
	$laserBlast.play()
	$laser.visible = true
	laserEmitting = true
	$laserTelegraph.restart()
	$laserTelegraph.emitting = false
	if dead:
		return
	
	
	var tween2 = create_tween()
	tween2.tween_property(self, "global_rotation", global_rotation+2*sweepRange*parity, 1)
	$steam1.emitting = true
	$steam2.emitting = true
	await get_tree().create_timer(1, false).timeout # laser time length
	$laser/AnimationPlayer.play("fadeOut")
	laserEmitting = false
	$steam1.emitting = false
	$steam2.emitting = false
	if dead:
		return

func boss3death():
	dead = true
	#removing hitboxes
	$hurtbox/hurtBox.set_deferred("disabled", true)
	$hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$hitBox.set_deferred("disabled", true)
	$fishDetector.enabled = false

	speed = 0
	laserEmitting = false
	$laser.visible  = false
	$deathParticle1.emitting = true
	await get_tree().create_timer(1, false).timeout
	$deathParticle1.emitting = false
	await get_tree().create_timer(0.5, false).timeout
	$deathSploison.play()
	$deathparticle2.restart()
	$deathparticle2.emitting = true
	globalSignals.emit_signal("boss3death")
	$alive.visible = false
	$dead.visible = true
	pass

func _on_navigation_agent_2d_navigation_finished() -> void:
	makePath()
	pass # Replace with function body.
