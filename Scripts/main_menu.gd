extends Control



@onready var fadeRect = load("res://scenes/ui/fade_rect.tscn")
@onready var menumusic: AudioStreamPlayer = $sounds/menumusic
@onready var menumusicloop: AudioStreamPlayer = $sounds/menumusicloop
@onready var foosh: AudioStreamPlayer = $sounds/ui/foosh
var skip = false

@onready var initial_buttons: VBoxContainer = $IntialMenu/InitialButtons
@onready var mode_buttons: HBoxContainer = $SecondMenu/modeButtons
@onready var back_button: Button = $SecondMenu/modeButtonsPanel/BackButton


#heart buttons
@onready var normal: TextureButton = $SecondMenu/modeButtons/normal
@onready var melee: TextureButton = $SecondMenu/modeButtons/melee


var menuStage = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	
	$SecondMenu.visible = false
	$"Options Menu".visible = false
	$IntialMenu.visible = true
	
	global.infHP = false
	global.infRoe = false
	
	#menumusic.volume_db = 0
	
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = false
	add_child(thunkfade)
	
	await get_tree().create_timer(0.5).timeout
	menumusic.play()
	
	setInitialSound()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (Input.is_action_pressed("sprint") || skip) && menuStage == 2:
		$Label.show()
	else:
		$Label.hide()
	if $"Options Menu".visible:
		soundOptions()
	if (Input.is_action_pressed("left") && Input.is_action_pressed("up") && Input.is_action_just_pressed("right")) :
		$"debug Menu".visible = !$"debug Menu".visible
			
	
	
	pass

func _on_play_pressed() -> void:
	$SecondMenu.visible = true
	
	$sounds/ui/select.play()
	menuStage = 2
	initial_buttons.visible = false
	
	mode_buttons.visible = true
	pass # Replace with function body.
func resetStats():
	## reset stats, just in case!
	global.speed = 7000
	global.shot_rate = 400 # 400 as default, reduce to increase
	global.shot_damage = 1.5 # 1.5 default
	global.slash_damage = global.shot_damage*3  # 3 default
	global.slash_rate = 400
	
	global.max_hp = 5
	global.hp = global.max_hp
	
	global.damageCost = 4
	global.rateCost = 4
	global.healthCost = 1
	global.roe = 0
	
	global.curBoss = 0

func onStartPressed() -> void:
	
	resetStats()

	skip = false
	if Input.is_action_pressed("sprint"):
		skip = true
	
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
		
	if is_instance_valid($"."):
		free()
	pass # Replace with function body.


func onOptionsPressed() -> void:
	$sounds/ui/select.play()
	pass # Replace with function body.


func onExitPressed() -> void:
	$sounds/ui/select.play()
	
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = true
	add_child(thunkfade)
	
	await get_tree().create_timer(0.5).timeout
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
	print_debug("loop")
	menumusicloop.play()

func _on_menumusicloop_finished() -> void:
	menumusicloop.play()
func _on_options_back_mouse_entered() -> void:
	$sounds/ui/hoveron.play()
	pass # Replace with function body.

func _on_normal_mouse_entered() -> void:
	$sounds/ui/hoveron.play()
	$SecondMenu/modeButtonsPanel/normalTip.visible = true
	pass # Replace with function body.
func _on_normal_mouse_exited() -> void:
	$SecondMenu/modeButtonsPanel/normalTip.visible = false
	pass # Replace with function body.

func _on_melee_mouse_entered() -> void:
	$sounds/ui/hoveron.play()
	$SecondMenu/modeButtonsPanel/meleeTip.visible = true
	pass # Replace with function body.
func _on_melee_mouse_exited() -> void:
	$SecondMenu/modeButtonsPanel/meleeTip.visible = false
	pass # Replace with function body.
	
func _on_back_button_mouse_entered() -> void:
	$sounds/ui/hoveron.play()
	pass # Replace with function body.
func _on_back_button_pressed() -> void:
	$SecondMenu.visible = false
	
	$sounds/ui/select.play()
	menuStage = 1
	initial_buttons.visible = true
	
	mode_buttons.visible = false
	


func _on_normal_pressed() -> void:
	global.heart = 1
	onStartPressed()
	pass # Replace with function body.
func _on_melee_pressed() -> void:
	global.heart = 2
	onStartPressed()
	pass # Replace with function body.

func setInitialSound():
	$"Options Menu/volumeControl/MusicSlider".value = settings.musicVol
	$"Options Menu/volumeControl/SFXSlider".value = settings.SFXVol
	
	
func soundOptions():
	var SFXid = AudioServer.get_bus_index("SFX")
	var Musicid = AudioServer.get_bus_index("Music")
	
	AudioServer.set_bus_volume_linear(Musicid, settings.musicVol)
	AudioServer.set_bus_volume_linear(SFXid, settings.SFXVol)
	settings.musicVol = $"Options Menu/volumeControl/MusicSlider".value
	settings.SFXVol = $"Options Menu/volumeControl/SFXSlider".value
	
	$"Options Menu/volumeControl/MusicSlider/volNum".text = str(snapped(settings.musicVol*100, 1)) + "%"
	$"Options Menu/volumeControl/SFXSlider/volNum".text = str(snapped(settings.SFXVol*100, 1)) + "%"
	
	pass

func _on_options_pressed() -> void:
	$sounds/ui/select.play()
	$"Options Menu".visible = true
	$IntialMenu.visible = false

func _on_options_back_pressed() -> void:
	$sounds/ui/select.play()
	$"Options Menu".visible = false
	$IntialMenu.visible = true


func _on_inf_hp_pressed() -> void:
	global.infHP = !global.infHP
	pass # Replace with function body.


func _on_inf_roe_pressed() -> void:
	global.infRoe = !global.infRoe
	pass # Replace with function body.
