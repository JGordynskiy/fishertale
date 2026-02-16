extends Node2D
var health = 3
var canTake = true
@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var rock_hit: AudioStreamPlayer = $rockHit
@onready var rock_destroy: AudioStreamPlayer = $rockDestroy

@onready var collision_polygon_2d: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if ((area.is_in_group("playerBullet")||area.is_in_group("playerSlash")) && canTake):
		if (area.is_in_group("playerSlash")):
			globalSignals.slashSuccess.emit()
		if (area.is_in_group("playerBullet")):
			area.get_parent().pop()
		
		health -= 1
		if health == 0:
			
			$Area2D/CollisionPolygon2D.set_deferred("disabled", true)
			$StaticBody2D/CollisionPolygon2D.set_deferred("disabled", true)
			
			particles.emitting = true
			sprite_2d.hide()
			rock_destroy.play()
			await get_tree().create_timer(2, false).timeout
			queue_free()
		else:
			rock_hit.play()
			canTake = false
			sprite.modulate.v = 0.5
			await get_tree().create_timer(0.2, false).timeout
			canTake = true
			sprite.modulate.v = 1
	pass # Replace with function body.
