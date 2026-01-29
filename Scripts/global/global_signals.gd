extends Node
#menu


#general
signal justPaused
signal justUnPaused

# Damage + gameOver
signal takeDmg
signal gameOver
signal actuallyTakeDmg

# boss Deaths
signal boss1death
signal boss2death

#Scene transition
signal gameTtoR
signal gameRto1
signal game1toR
signal gameRto2
signal game2toR
signal gameRto3


#Boss2
signal boss2Start


signal slashSuccess

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
