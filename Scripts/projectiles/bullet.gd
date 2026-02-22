extends CharacterBody2D





@onready var animated_sprite: AnimatedSprite2D = $Area2D/AnimatedSprite2D
@onready var rng = RandomNumberGenerator.new()

@onready var fish = get_tree().get_current_scene().get_node("fish") 

@onready var soundPlayed : int


var range = global.bulletRange # should be cahnged for every bullet, si by default the player's range
@export var SHOT_SPEED = 15000

var curRange
var dir : float
var spawnPos : Vector2
var spawnRot : float
var popping = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GPUParticles2D.amount = 3 + int(global.shot_damage)
	
	$GPUParticles2D.emitting = true
	#print(dir)
	soundPlayed = 0
	scale.x = 1*sqrt(global.shot_damage)
	scale.y = 1*sqrt(global.shot_damage)
	animated_sprite.play("shoot")
	global_position = spawnPos
	curRange = 0
	
	#randomization
	var rand = rng.randf_range(-global.accuracy,global.accuracy)
	global_rotation = spawnRot + rand
	dir += rand
	rng.randf()
	velocity = Vector2(0, -SHOT_SPEED).rotated(dir)
	pass #


func pop():
	popping = true
	
	animated_sprite.play("pop")
	if soundPlayed == 0:
		#rng.randomize()
		#global_rotation = rng.randf_range(0, 2*PI)
		soundPlayed = 1
		fish.shootPop()
	velocity = Vector2(0, 0)
	await get_tree().create_timer(0.1).timeout
	queue_free()
	pass
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	curRange += 700*delta
	if curRange > range:
		pop()
	#if !(popping):
		#velocity.y += 9800 * delta
	
	move_and_slide()
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("objects"):
		curRange = range+10
		
	pass # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("objects"):
		curRange = range+10
	if area.is_in_group("enemyHitbox"):
		curRange = range+10
		
	pass # Replace with function body.
