extends CharacterBody2D
@onready var sprite: Sprite2D = $Sprite2D

@onready var game = $".."
@onready var fish = $"../fish"
@onready var cam = fish.get_node("followCam")
@onready var death: AudioStreamPlayer2D = $death

@onready var particles: GPUParticles2D = $GPUParticles2D

@onready var danger: CollisionShape2D = $lungeFish/danger
@onready var collision: CollisionShape2D = $CollisionShape2D

#roe popup
@onready var roePopup = load("res://scenes/objects/roe_popup.tscn")

var invuln = false

@onready var navAgent: NavigationAgent2D = $NavigationAgent2D
@onready var pathPos : Vector2
var hp =3
var speed = 0

var genTimer = 0

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pathPos = navAgent.get_next_path_position()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	genTimer += rng.randi_range(20, 150)*delta
	
	if speed > 0:
		speed -= 10000*delta
	
	if genTimer > 90:
		makePath()
		genTimer = 0
		seed(global_position.x + global_position.y)
		rng.randomize()
		speed = 8000 * rng.randf_range(0.8, 1.2)
		
		#var tween = create_tween()
		#tween.tween_property(self, "speed", 0, 2)
		
		
	
	if cam.tutStage > 3:
		
		pathPos = navAgent.get_next_path_position()
		var dir = (pathPos - global_position).normalized()
		velocity = dir*speed
	if hp > 0:
		look_at(fish.global_position)
	
	if rotation < -1*(PI/2) || rotation > PI/2:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	pass
	
	move_and_slide()
func makePath():
	navAgent.target_position = fish.global_position


func _on_navigation_agent_2d_link_reached(details: Dictionary) -> void:
	makePath()
	pass # Replace with function body.


func _on_lunge_fish_area_entered(area: Area2D) -> void:
	
	if (area.is_in_group("playerBullet") || area.is_in_group("playerSlash")) && !invuln:
		if (area.is_in_group("playerSlash")):
			globalSignals.slashSuccess.emit()
		invuln = true
		hp -= 1
		sprite.modulate.v = 0.5
		await get_tree().create_timer(0.1, false).timeout
		sprite.modulate.v = 1
		invuln = false
	if hp < 1 && !danger.disabled:
		speed = 0
		game.enemyCount -= 1
		velocity = Vector2(0, 0)
		sprite.hide()
		death.play()
		particles.emitting = true
		danger.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		
		#roe Popup
		var roeP = roePopup.instantiate()
		roeP.global_position = global_position
		roeP.actualText = "+"+str(2)
		global.roe += 2
		game.add_child(roeP)
		
		await get_tree().create_timer(1, false).timeout
		queue_free()
		
	pass # Replace with function body.
