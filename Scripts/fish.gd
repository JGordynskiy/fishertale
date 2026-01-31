extends CharacterBody2D


var mult = 1



@onready var game  = get_owner()# I guess this gets  reference to the game node? but why?
@onready var bullet = load("res://scenes/bullet.tscn") #!! important!! This loads a scene from res://
@onready var camera = $followCam
@onready var cloud = load("res://scenes/particles/dash_cloud.tscn")
@onready var bubbles = load("res://scenes/particles/bubble_explosion.tscn")
@onready var deathGore = load("res://scenes/particles/fish_explosion.tscn")

#Roe
@onready var roePopup = load("res://scenes/objects/roe_popup.tscn")

#Slash
@onready var slashSpr: AnimatedSprite2D = $slash
@onready var slashsfx: AudioStreamPlayer = $sounds/slash
@onready var slashhitbox: Area2D = $slashhitbox
@onready var slashlandsfx: AudioStreamPlayer = $sounds/slashland
var slashCount = 0

#visual+sound
@onready var sprite := $AnimatedSprite2D
@onready var dashVisual1count = 0
@onready var dashVisual1: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var swimSilent = 1
@onready var movebubbles: GPUParticles2D = $movebubbles
@onready var blink: Polygon2D = $AnimatedSprite2D/blink
var blinkCount = 0



@onready var rng = RandomNumberGenerator.new()
var invulnerable = false

#only for Boss1
@onready var evilFish = game.get_node("evilFish") 

@export var slash_timer = 0

@export var shot_timer = 0
var dangerTouching = 0

var iFrames = 90
var iFrameCount = iFrames

var dashCool = 60
var dashCount = 60

var canShoot = true
var canMove = true


func _ready():
	blink.visible = false
	$CollisionShape2D.disabled = false
	$"fish/CollisionShape2D".disabled = false
	canMove = true
	canShoot = true
	sprite.play("idle")
	
	#kills fish and flashes screne red on death/dmg
	globalSignals.gameOver.connect(death)
	globalSignals.takeDmg.connect(takeDamage)
	
	#makes fish spin into whirlpool
	globalSignals.gameTtoR.connect(transition)
	globalSignals.game1toR.connect(transition)
	globalSignals.game2toR.connect(transition)
	
	#plays sound and reduces slash timer on succesful slash
	globalSignals.slashSuccess.connect(slashSuccess)
	$Sprite2D.self_modulate.a = 0
	
	#ensure slash sizes are correct
	$slashhitbox/CollisionShape2D.position = Vector2(global.slash_x, 0)
	$slashhitbox/CollisionShape2D.scale.x = global.slash_scale
	$slash.position.x = global.slash_x*1.8 + 300
	
	
	

func death():
	canShoot = false
	canMove = false
	$"AnimatedSprite2D".play("dead")
	$"totalPlayer".play("death")
	$"sounds/deathSound".play()
	$CollisionShape2D.disabled = true
	$"fish/CollisionShape2D".disabled = true
	await get_tree().create_timer(1.5).timeout
	var instance = deathGore.instantiate()
	$"sounds/deathPop".play()
	game.add_child(instance)

func transition():
	var whirlpool = $"../whirlpool"
	
	canMove = false
	canShoot = false
	$"AnimatedSprite2D/AnimationPlayer".play("transSpin")
	var tween = create_tween()
	tween.tween_property(self, "global_position", whirlpool.global_position, 1)

func slash():
	if (slash_timer > 0 || !canShoot):
		return
	slash_timer = global.slash_rate
	$"AnimatedSprite2D/AnimationPlayer".play("RESET")
	if (slashCount == 0):
		slashCount = 1
		slashSpr.flip_v = false
		$"AnimatedSprite2D/AnimationPlayer".play("spin")
	else:
		slashCount = 0;
		slashSpr.flip_v = true
		$"AnimatedSprite2D/AnimationPlayer".play("counterSpin")
	slashSpr.play("slash")
	rng.randomize()
	
	slashsfx.pitch_scale = rng.randf_range(0.6, 1)
	slashsfx.play()
	
	$slashhitbox/CollisionShape2D.disabled = false
	await get_tree().create_timer(0.2, false).timeout
	$slashhitbox/CollisionShape2D.disabled = true
	
	pass

#Takes care of fire rate, and spawn new bullets aimed at the cursor
func shoot():
	if (shot_timer > 0 || !canShoot):
		return
	rng.randomize()
	$"sounds/shoot".pitch_scale = rng.randf_range(0.9, 1.1)
	$"sounds/shoot".play()
	shot_timer = global.shot_rate
	
	#SPAWN BULLET
	var instance = bullet.instantiate()
	
	instance.curRange = 0
	instance.range = global.bulletRange
	instance.dir = rotation + (PI/2)
	instance.spawnPos = global_position
	instance.spawnRot = rotation + (PI/2)
	
	game.add_child.call_deferred(instance)
	$"AnimatedSprite2D/AnimationPlayer".stop()
	$"AnimatedSprite2D/AnimationPlayer".play("RESET")
	$"AnimatedSprite2D/AnimationPlayer".play("recoil")
	

	#SPAWN BUBBLE PARTICLES
	
	
func shootPop():
	rng.randomize()
	$"sounds/pop".pitch_scale = randf_range(0.9, 1.1)
	$"sounds/pop".play()

#Takes care of movement, as well as sprinting
func get_input():
	var direction = Input.get_vector("left", "right", "up", "down")
	
	#Acceleration for Dash
	if Input.is_action_pressed("sprint"):
		dash()
	
	#if Input.is_action_just_pressed("altFire"):
		#slash()
		
	if Input.is_action_pressed("click"):
		if global.heart == 1:
			shoot()
		if global.heart == 2:
			slash()
	
	velocity = direction * global.speed * mult


#Takes care of damage, but only if not from invinibility frames
func takeDamage():
	var pauseTime : float
	if global.hp > 1:
		pauseTime = 0.15
	else:
		pauseTime = 0.4
	
	if global.hp < 1:
		return
	if iFrameCount >= iFrames:
		#global.emit_signal("actuallyTakeDmg")
		camera.takeDamage()
		#await get_tree().create_timer(pauseTime).timeout
		
		global.hp -= 1
		if global.hp >0:
			
			
			$"sounds/damage".play()
			var instance = bubbles.instantiate()
			instance.particleTime = 10.0
			instance.particleCount = 60
			instance.pos = global_position
			game.add_child(instance)
			
			
			##pausing game upon tkaing damage
			#global.camZoom *= 2
			#global.pausable = false
			#get_tree().paused = true
			#await get_tree().physics_frame
			#await get_tree().create_timer(pauseTime, true).timeout
			#get_tree().paused = false
			#global.pausable = true
			#global.camZoom *= 0.5
			
			
		iFrameCount = 0
	
	
func dash():
	if (dashCount > dashCool && canMove):
		$"sounds/woosh".play()
		dashVisual1count = 1
		if iFrameCount > 76:
			iFrameCount = 75
		#game.add_child(cloud.instantiate())
		mult = 5
		dashCount = 0
		var instance = bubbles.instantiate()
		instance.particleTime = 1.0
		instance.particleCount = 20
		instance.pos = global_position
		game.add_child(instance)

func blinker():
	blinkCount += 1
	
	if (blinkCount == 100 && iFrameCount > iFrames):
		
		rng.randomize()
		blinkCount = rng.randi_range(-50, 0)
		blink.visible = true
		await get_tree().create_timer(0.12, false).timeout
		blink.visible = false

func _process(delta):
	#shows fire if debug damage
	if (global.shot_damage > 30):
		$fireParticles.emitting = true
	else:
		$fireParticles.emitting = false
	
	
	#removes inviniciblity frames
	iFrameCount += 60*delta
	
	if iFrameCount < iFrames:
		invulnerable = true
	else:
		invulnerable = false
	blinker()
	
	
	slash_timer -=10
	shot_timer = shot_timer - 1000*delta
	#Keeps the speed
	if mult > 1:
		mult -= 0.3
	if mult < 1:
		mult = 1
	dashCount += 60*delta
	
	
	if (dashVisual1count == 1):
		if (dashCount > dashCool):
			dashVisual1count = 0
			dashVisual1.play("recover")
			$"sounds/dashrecover".play()
	
	# Keeps sprite Upright
	if rotation < -1*(PI/2) || rotation > PI/2:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
		
	#bubble aesthetic
	if (velocity != Vector2(0,0)):
		movebubbles.emitting = true
		
	else:
		movebubbles.emitting = false
		
		
	# iFrame visibility
	if iFrameCount < iFrames:
		sprite.self_modulate.a = 0.5
		
		
	else:
		sprite.self_modulate.a = 1
		sprite.speed_scale = 1
	
	if global.hp > 0 || canMove:
		look_at(get_global_mouse_position())
	if velocity.length() > 0:
		sprite.speed_scale = 3
		if swimSilent == 1:
			rng.randomize()
			$"sounds/swim".pitch_scale = ((rng.randf()-0.5)/2)+0.5
			$"sounds/swim".play()
			swimSilent = 0
			await get_tree().create_timer(0.5).timeout
			swimSilent = 1
	else:
		if dangerTouching == 0:
			sprite.speed_scale = 1


func _on_swim_finished() -> void:
	pass

func _physics_process(delta):
	if global.hp < 1:
		iFrameCount = 9999
	
	
	if dangerTouching > 0:
		takeDamage()
	#get_shoot_input()
	if canMove:
		get_input()
	else:
		velocity = Vector2(0, 0)
	move_and_slide()
	
# take damage from Obstacles
func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("dangerObj"):
		if(area.name == "evilFish" && evilFish.boss1hp < 1):
			return
		dangerTouching +=1
	pass 

#stop taking damage from obstacles
func _on_area_2d_area_exited(area: Area2D) -> void:
	
	if area.is_in_group("dangerObj"):
		dangerTouching -= 1
	
	pass 
	
#for slash sound effect + roe
func slashSuccess():
	if (!camera.tutorial):
		pass
		
		## Gives chance based Roe
		#rng.randomize()
		#var rand = rng.randi_range(1,2)
		#if (rand == 1):
			#var instance = roePopup.instantiate()
			#rng.randomize()
			#var randRoe = rng.randi_range(1,3)
			#instance.actualText = "+"+str(randRoe)
			#
			#global.roe+= randRoe
			#
			#instance.global_position = global_position
			#rng.randomize()
			#instance.global_position.x += randf_range(-1000,1000)
			#rng.randomize()
			#instance.global_position.y += randf_range(-1000,1000)
			#game.add_child(instance)
			
	slashlandsfx.pitch_scale = rng.randf_range(1, 1.4)
	slashlandsfx.play()
	slash_timer /= 5
	
