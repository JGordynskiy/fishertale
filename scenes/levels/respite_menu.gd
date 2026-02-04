extends Control
@onready var readyB: Button = $ReadyButton
@onready var hover_on: AudioStreamPlayer = $hoverOn
@onready var music: AudioStreamPlayer = $Music

@onready var select: AudioStreamPlayer = $select
@onready var theFadeRect = load("res://scenes/ui/fade_rect.tscn")

#buttons
@onready var damage: Button = $upgrades/Damage
@onready var rate: Button = $upgrades/rate
@onready var health: Button = $upgrades/health

@onready var roe_amount: RichTextLabel = $Roe/roeAmount
@onready var roe_hint: RichTextLabel = $Roe/RoeHint

#upgrade cost

@onready var boss1img: Sprite2D = $enemyMonitor/bossImages/boss1Img
@onready var boss2img: AnimatedSprite2D = $enemyMonitor/bossImages/boss2img



var transitioning = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transitioning = false
	
	var thunkfade = theFadeRect.instantiate()
	thunkfade.type = false
	add_child(thunkfade)
	
	
	if global.curBoss == 0 || global.curBoss == 1:
		boss1img.modulate.a = 255
	else:
		boss1img.modulate.a = 0
		
	if global.curBoss == 2:
		boss2img.modulate.a = 255
	else:
		boss2img.modulate.a = 0	
	
	if global.curBoss == 3:
		$enemyMonitor/bossImages/boss3img.modulate.a = 255
	else:
		$enemyMonitor/bossImages/boss3img.modulate.a = 0	
	#await get_tree().create_timer(0.5, false).timeout
	music.play()
		
	
## BOSS DESCRIPTIONS
func _on_enemy_monitor_box_mouse_entered() -> void:
	$enemyMonitor/hints.visible = true
func _on_enemy_monitor_box_mouse_exited() -> void:
	$enemyMonitor/hints.visible = false
	
## FISH STATS
func _on_friendly_monitor_box_mouse_entered() -> void:
	$FriendlyMonitor/stats/DmgText.text = "DMG: "+str(global.shot_damage)
	
	if global.heart == 1:
		$FriendlyMonitor/stats/rate.visible = true
		$FriendlyMonitor/stats/rate.text = "Shot Rate: "+str(int(global.shot_rate))
	if global.heart == 2:
		$FriendlyMonitor/stats/rate.visible = false	
	
	$FriendlyMonitor/stats.visible = true
	pass # Replace with function body.
func _on_friendly_monitor_box_mouse_exited() -> void:
	$FriendlyMonitor/stats.visible = false
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	roe_amount.text = str(global.roe)
	
	#DEBUG
	if Input.is_action_just_pressed("DEBUGcannonshoot"):
		global.roe += 1
	
	
	## BOSS DESCRIPTIONS
	
	#boss 1
	if global.curBoss == 1:
		$enemyMonitor/hints/boss1.visible = true
	else:
		$enemyMonitor/hints/boss1.visible = false
	
	#boss 2
	if global.curBoss == 2:
		$enemyMonitor/hints/boss2.visible = true
	else:
		$enemyMonitor/hints/boss2.visible = false
		
	#boss 3	
	if global.curBoss == 3:
		$enemyMonitor/hints/boss3.visible = true
	else:
		$enemyMonitor/hints/boss3.visible = false
	
	
	
	#ready Button
	if global.curBoss > 3:
		$ReadyButton.disabled = true
	else:
		$ReadyButton.disabled = false
	
	#damage
	damage.text = str(global.damageCost)
	if global.roe < global.damageCost:
		damage.disabled = true
		pass
	else:
		damage.disabled = false
	pass
	
	#rate
	rate.text = str(global.rateCost)
	if global.roe < global.rateCost:
		rate.disabled = true
		pass
	else:
		rate.disabled = false
	pass

	#health
	health.text = str(int(global.healthCost))
	
	if global.roe < global.healthCost || global.hp >= global.max_hp:
		health.disabled = true
		pass
	else:
		health.disabled = false
	pass

func _on_ready_button_pressed() -> void:
	if !transitioning:
		select.play()
		transitioning = true
		var tween = create_tween()
		tween.tween_property(music, "volume_db", -99, 1)
	
		var thunkfade = theFadeRect.instantiate()
		thunkfade.type = true
		add_child(thunkfade)
		
		if global.curBoss == 1 || global.curBoss == 0:
			
			globalSignals.emit_signal("gameRto1")
		elif global.curBoss == 2:
			globalSignals.emit_signal("gameRto2")
		elif global.curBoss == 3:
			globalSignals.emit_signal("gameRto3")
		
	pass # Replace with function body.


func _on_ready_button_mouse_entered() -> void:
	if !transitioning && !$ReadyButton.disabled:
		hover_on.play()
	pass # Replace with function body.

func _on_roe_button_mouse_entered() -> void:
	hover_on.play()
	roe_hint.visible = true
	pass # Replace with function body.
func _on_roe_button_mouse_exited() -> void:
	roe_hint.visible = false
	pass # Replace with function body.


#DAMAGE
func _on_damage_pressed() -> void:
	select.play()
	global.shot_damage += 0.5
	global.roe -= global.damageCost
	global.damageCost += 1
	pass # Replace with function body.
func _on_damage_mouse_entered() -> void:
	if damage.disabled == false:
		hover_on.play()
	pass # Replace with function body.
	
#rate
func _on_rate_pressed() -> void:
	
	select.play()
	global.shot_rate *= 0.92
	
	#melee changes
	global.slash_scale += 10
	global.slash_x += 130
	
	global.roe -= global.rateCost
	global.rateCost += 1
	pass # Replace with function body.
func _on_rate_mouse_entered() -> void:
	if rate.disabled == false:
		hover_on.play()
	pass # Replace with function body.

#health
func _on_health_pressed() -> void:
	select.play()
	global.hp += 1
	global.roe -= int(global.healthCost)
	#global.healthCost += 0.5
	pass # Replace with function body.


func _on_health_mouse_entered() -> void:
	if health.disabled == false:
		hover_on.play()
	pass # Replace with function body.
