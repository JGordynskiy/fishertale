extends CanvasLayer

@onready var pause_menu: Control = %"Pause Menu/CanvasLayer"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fadeRect = load("res://scenes/ui/fade_rect.tscn")
@onready var game  = get_owner()

@onready var cam = $"../fish/followCam"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globalSignals.gameOver.connect(onDeath)
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass

func onDeath():
	global.pausable = false
	
	await get_tree().create_timer(3).timeout
	show()
	animation_player.play("fadein")
	await get_tree().create_timer(1).timeout
	
	pass


func _on_retry_pressed() -> void:
	
	
	if cam.tutorial:
		$"sounds/ui/select".play()
		var thunkfade = fadeRect.instantiate()
		thunkfade.type = false
		game.add_child(thunkfade)
		await get_tree().create_timer(1.3).timeout
		global.hp = global.max_hp
		global.goto_scene("res://scenes/levels/game_t.tscn")
	if global.debug:
		$"sounds/ui/select".play()
		await get_tree().create_timer(0.3).timeout
		global.hp = global.max_hp
		global.goto_scene("res://scenes/levels/dojo.tscn")
		
	$"sounds/ui/select".play()
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = true
	game.add_child(thunkfade)
	await get_tree().create_timer(0.6).timeout
	global.hp = global.max_hp
	
	if global.curBoss != 1:
		global.roe -= 2
		if global.roe < 0:
			global.roe = 0
	global.goto_scene("res://scenes/levels/respite_menu.tscn")
	
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	$"sounds/ui/select".play()
	var thunkfade = fadeRect.instantiate()
	thunkfade.type = true
	game.add_child(thunkfade)
	
	await get_tree().create_timer(0.3).timeout
	global.goto_scene("res://scenes/levels/main_menu.tscn")
	
	
	pass # Replace with function body.

func _on_retry_mouse_entered() -> void:
	$"sounds/ui/hoveron".play()
	pass # Replace with function body.


func _on_quit_mouse_entered() -> void:
	$"sounds/ui/hoveron".play()
	pass # Replace with function body.


func _on_quitmaybe_pressed() -> void:
	$"sounds/ui/select".play()
	$really.visible = true
	pass # Replace with function body.


func _on_nvm_pressed() -> void:
	$"sounds/ui/select".play()
	$really.visible = false
	pass # Replace with function body.


func _on_nvm_mouse_entered() -> void:
	$"sounds/ui/hoveron".play()
	pass # Replace with function body.
