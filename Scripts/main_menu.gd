extends Control

@onready var panel: Panel = $BLACKSCREEN
@onready var animation_player: AnimationPlayer = $BLACKSCREEN/AnimationPlayer
@onready var fadeRect = load("res://scenes/ui/fade_rect.tscn")
@onready var menumusic: AudioStreamPlayer = $sounds/menumusic
@onready var menumusicloop: AudioStreamPlayer = $sounds/menumusicloop
@onready var foosh: AudioStreamPlayer = $sounds/ui/foosh
var skip = false

@onready var initial_buttons: VBoxContainer = $InitialButtons
@onready var final_buttons: BoxContainer = $finalButtons
@onready var mode_buttons: HBoxContainer = $modeButtons
@onready var back_button: Button = $modeButtonsPanel/BackButton


#heart buttons
@onready var normal: TextureButton = $modeButtons/normal
@onready var melee: TextureButton = $modeButtons/melee


var menuStage = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	$modeButtonsPanel.visible = false
	$"choose a heart".visible = false
	mode_buttons.visible = false
	initial_buttons.visible = true
	final_buttons.visible = false
	menumusic.volume_db = 0
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = false
	add_child(thunkfade)
	await get_tree().create_timer(0.5).timeout
	menumusic.play()
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_pressed("sprint") || skip) && menuStage == 2:
		$Label.show()
	else:
		$Label.hide()
	
	pass

func _on_play_pressed() -> void:
	$modeButtonsPanel.visible = true
	$"choose a heart".visible = true
	$sounds/ui/select.play()
	menuStage = 2
	initial_buttons.visible = false
	final_buttons.visible = true
	mode_buttons.visible = true
	pass # Replace with function body.


func onStartPressed() -> void:
	skip = false
	if Input.is_action_pressed("sprint"):
		skip = true
	global.hp = global.max_hp
	$sounds/ui/select.play()
	
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = true
	add_child(thunkfade)
	
	var tween = create_tween()
	tween.tween_property(menumusic, "volume_db", -79, 0.5)
	var tween2 = create_tween()
	tween2.tween_property(menumusicloop, "volume_db", -79, 0.5)
	foosh.play()
	await get_tree().create_timer(2).timeout
	global.inGame = true
	if skip:
		global.roe = 6
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

func _on_play_mouse_entered() -> void:
	$sounds/ui/hoveron.play()
	pass # Replace with function body.


func _on_menumusic_finished() -> void:
	menumusicloop.play()
	pass # Replace with function body.


func _on_normal_mouse_entered() -> void:
	$sounds/ui/hoveron.play()
	$modeButtonsPanel/normalTip.visible = true
	pass # Replace with function body.
func _on_normal_mouse_exited() -> void:
	$modeButtonsPanel/normalTip.visible = false
	pass # Replace with function body.
	
func _on_melee_mouse_entered() -> void:
	$sounds/ui/hoveron.play()
	$modeButtonsPanel/meleeTip.visible = true
	pass # Replace with function body.
func _on_melee_mouse_exited() -> void:
	$modeButtonsPanel/meleeTip.visible = false
	pass # Replace with function body.
	
func _on_back_button_mouse_entered() -> void:
	$sounds/ui/hoveron.play()
	pass # Replace with function body.
func _on_back_button_pressed() -> void:
	$modeButtonsPanel.visible = false
	$"choose a heart".visible = false
	$sounds/ui/select.play()
	menuStage = 1
	initial_buttons.visible = true
	final_buttons.visible = false
	mode_buttons.visible = false
	


func _on_normal_pressed() -> void:
	global.heart = 1
	onStartPressed()
	pass # Replace with function body.
func _on_melee_pressed() -> void:
	global.heart = 2
	onStartPressed()
	pass # Replace with function body.
