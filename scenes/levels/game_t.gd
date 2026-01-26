extends Node2D

@onready var fish: CharacterBody2D = $fish
@onready var camera: Camera2D = $fish/followCam
@onready var calmloop: AudioStreamPlayer = $calmloop
@onready var calmfirst: AudioStreamPlayer = $calmfirst
@onready var calmactivity: AudioStreamPlayer = $calmactivity

var enemyCount = 3

@onready var animation_player: AnimationPlayer = $faderect/faderect/AnimationPlayer

@onready var crate = load("res://scenes/object.tscn")
@onready var whirlpool = load("res://scenes/entities/whirlpool.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globalSignals.gameOver.connect(gameOver)
	globalSignals.gameTtoR.connect(transition)
	$"hpBar/Panel".visible = false
	camera.reset_smoothing()
	#await get_tree().create_timer(0.5).timeout
	animation_player.play("fadeout")
	calmactivity.volume_db = -79
	calmactivity.play()
	calmfirst.play()
	camera.tutorial = true
	camera.tutStage = 0
	
	global.pausable = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if enemyCount == 0:
		enemyCount = -1
		
		await get_tree().create_timer(1, false).timeout
		var tween2 = create_tween()
		tween2.tween_property(calmactivity, "volume_db", -79, 8)
		await get_tree().create_timer(1, false).timeout
		
		var instance = whirlpool.instantiate()
		instance.global_position = Vector2(-33000, 11600) 
		add_child(instance)
		
		
	pass


func _on_trigger_1_area_entered(area: Area2D) -> void:
	if area.name != "fish":
		return
	if camera.tutStage == 0:
		
		camera.tutStage = 1
	pass # Replace with function body.


func _on_trigger_2_area_entered(area: Area2D) -> void:
	if area.name != "fish":
		return
	if camera.tutStage == 1:
		
		camera.tutStage = 2
	pass # Replace with function body.


func _on_trigger_3_area_entered(area: Area2D) -> void:
	if area.name != "fish":
		return
	if camera.tutStage == 2:
		await get_tree().create_timer(0.25, false).timeout
		$"hpBar/Panel/Sprite2D/AnimationPlayer".play("spawnIn")
		$"hpBar/Label/AnimationPlayer".play("spawnIn")
		
		var tween = create_tween()
		tween.tween_property(camera, "zoom", Vector2(0.1, 0.1), 0.5)
		camera.tutStage = 3
		global.pausable = true
		$"hpBar/Panel".visible = true
		
	pass # Replace with function body.
	
	
func _on_trigger_4_area_entered(area: Area2D) -> void:
	if area.name != "fish":
		return
	if camera.tutStage == 3:
		var tween = create_tween()
		tween.tween_property(camera, "zoom", Vector2(0.06, 0.06), 0.5)
		
		
		var instance = crate.instantiate()
		instance.global_position = Vector2(7000, -3500)
		instance.rotation = 1
		add_child(instance)
		
		camera.tutStage = 4
		var tween2 = create_tween()
		calmactivity.volume_db = -30
		tween2.tween_property(calmactivity, "volume_db", 0, 5)
		#calmactivity.volume_db = 0
	pass # Replace with function body.

func gameOver():
	var tween = create_tween()
	tween.tween_property(calmloop, "volume_db", -79, 1.5)
	tween.tween_property(calmfirst, "volume_db", -79, 1.5)
	tween.tween_property(calmactivity, "volume_db", -79, 1.5)
	tween.tween_property(calmloop, "pitch_scale", -0.2, 1.5)
	tween.tween_property(calmfirst, "pitch_scale", -0.2, 1.5)
	tween.tween_property(calmactivity, "pitch_scale", -0.2, 1.5)


func _on_calmfirst_finished() -> void:
	calmloop.play()
	pass # Replace with function body.

func transition():
	
	global.curBoss = 1
	var tween = create_tween()
	tween.tween_property(calmloop, "volume_db", -79, 0.5)
	tween.tween_property(calmfirst, "volume_db", -79, 0.5)
	tween.tween_property(calmactivity, "volume_db", -79, 0.5)
