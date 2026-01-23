extends Control

@onready var panel: Panel = $Panel
@onready var animation_player: AnimationPlayer = $Panel/AnimationPlayer
@onready var menumusic: AudioStreamPlayer = $sounds/menumusic
@onready var menumusicloop: AudioStreamPlayer = $sounds/menumusicloop
@onready var foosh: AudioStreamPlayer = $sounds/ui/foosh
var skip = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	menumusic.volume_db = 0
	await get_tree().create_timer(0.5).timeout
	menumusic.play()
	animation_player.play("fade away")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("sprint") || skip:
		$Label.show()
	else:
		$Label.hide()
	
	pass


func onStartPressed() -> void:
	skip = false
	if Input.is_action_pressed("sprint"):
		skip = true
	global.hp = global.max_hp
	$sounds/ui/select.play()
	animation_player.play("fadein")
	var tween = create_tween()
	tween.tween_property(menumusic, "volume_db", -79, 0.5)
	var tween2 = create_tween()
	tween2.tween_property(menumusicloop, "volume_db", -79, 0.5)
	foosh.play()
	await get_tree().create_timer(2).timeout
	global.inGame = true
	if skip:
		global.curBoss = 1
		global.goto_scene("res://scenes/levels/respite_menu.tscn")
	else:
		global.goto_scene("res://scenes/levels/game_t.tscn")
	pass # Replace with function body.


func onOptionsPressed() -> void:
	$sounds/ui/select.play()
	
	pass # Replace with function body.


func onExitPressed() -> void:
	$sounds/ui/select.play()
	get_tree().quit()
	pass # Replace with function body.

 
# =========== BUTTON SOUNDS ============
func _on_button_mouse_entered() -> void:
	$sounds/ui/hoveron.play()
	pass # Replace with function body.
func _on_options_mouse_entered() -> void:
	$sounds/ui/hoveron.play()
	pass # Replace with function body.
func _on_exit_mouse_entered() -> void:
	$sounds/ui/hoveron.play()
	pass # Replace with function body
#func _on_button_mouse_exited() -> void:
	#$sounds/ui/hoveroff.play()
	#pass # Replace with function body.
#func _on_options_mouse_exited() -> void:
	#$sounds/ui/hoveroff.play()
	#pass # Replace with function body.
#func _on_exit_mouse_exited() -> void:
	#$sounds/ui/hoveroff.play()
	#pass # Replace with function body.


func _on_menumusic_finished() -> void:
	menumusicloop.play()
	pass # Replace with function body.
