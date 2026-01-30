extends CharacterBody2D
@onready var fishRay: RayCast2D = $fishDetector
@onready var laserRay: RayCast2D = $laserRay
@onready var laser: Line2D = $laser
@onready var fish = get_node("../fish")
var rng = RandomNumberGenerator.new()

@onready var navAgent: NavigationAgent2D = $NavigationAgent2D

var laserEmitting = false

var iFrames = 0
var coolDown = 30
var boss3hp = 200


func _ready() -> void:
	laser.visible = false
	pass 

func _process(delta: float) -> void:
	
	var laserLength = global_position.distance_to(laserRay.get_collision_point())
	laser.points = PackedVector2Array([Vector2(0, 0), Vector2(laserLength/22*-1, 0)])
	
	
	iFrames -= 60*delta
	coolDown -= 30*delta
	#print_debug(coolDown)
	#invulernability frames
	if iFrames > 0:
		modulate.v = 0.5
	else:
		modulate.v = 1
	pass
	
	# take Damage from laser
	if fishRay.get_collider().is_in_group("player") && laserEmitting:
		globalSignals.takeDmg.emit()
	
	#invulnerability Visual
	$invulenrablePolygon.visible = !laserEmitting
	
	if coolDown < 0 && global.hp > 0:
		attackSchedule()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if (!laserEmitting):
		return
	if area.is_in_group("playerBullet"):
		if iFrames < 0:
			iFrames = 10
	if area.is_in_group("playerSlash"):
		if iFrames < 0:
			globalSignals.slashSuccess.emit()
			iFrames = 10
	pass 

func attackSchedule():
	sweepLaser()
	pass
	
func sweepLaser():
	
	$laserTelegraph.emitting = false
	rng.randomize()
	var sweepRange = randf_range(0.4, 0.8)
	var parity = 0
	while (parity == 0):
		rng.randomize()
		parity = randi_range(-1, 1)
	
	
	coolDown = 100
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
	
	# setting the laser correctly!
	
	
	await get_tree().create_timer(1, false).timeout #telegraph time
	
	#Actually start the laser
	$laser/AnimationPlayer.play("laserIn")
	$laserBlast.play()
	$laser.visible = true
	laserEmitting = true
	$laserTelegraph.restart()
	$laserTelegraph.emitting = false
	
	
	
	var tween2 = create_tween()
	tween2.tween_property(self, "global_rotation", global_rotation+2*sweepRange*parity, 1)
	
	
	await get_tree().create_timer(1, false).timeout # laser time length
	$laser/AnimationPlayer.play("fadeOut")
	laserEmitting = false
	
