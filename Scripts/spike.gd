extends Area2D

var isIn = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	rotation += 0.2
	pass

func _on_body_entered(body: Node2D) -> void:
	isIn = true
	if body.name == "fish":
		print("firstone")
		if body.invulnerable == false:
			print("secondone")
			
			body.canMove = false
			body.position.x = body.position.x - 3000
			await get_tree().create_timer(1, false).timeout
			body.canMove = true
		
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	isIn = false
	pass # Replace with function body.
