extends State
class_name FrogIdle

@export var anim: AnimatedSprite2D
@export var frog: Node2D


func Enter():
	anim.play("Idle")


func Physics_Update(_delta):
	# falling
	if frog.velocity.y > 0:
		anim.play("Fall")
	# floating
	elif frog.velocity.y < 0:
		anim.play("Jump")
	# idle
	else:
		anim.play("Idle")


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		# turn to player
		var right = body.position.x > frog.position.x
		anim.flip_h = right

		Transitioned.emit(self, "FrogAggro")
