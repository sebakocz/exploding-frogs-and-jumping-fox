extends CharacterBody2D

const GROUND_FRICTION = 0.01

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var frogStateMachine : StateMachine
@export var deathState : State
@export var deathAudio : AudioStreamPlayer

@onready var anim = get_node("AnimatedSprite2D")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Apply the friction.
	velocity.x = lerp(velocity.x, 0.0, GROUND_FRICTION)

	move_and_slide()
	

func _on_damage_detection_body_entered(body:Node2D):
	if body.name == "Player" and anim.animation != "Death":
		body.damaged()

		# own knockback
		velocity = Vector2(randf(), -1.0) * 100.0


func _on_death_detection_body_entered(body):
	if body.name == "Player":
		die()

func die():
	anim.play("Death")
	deathAudio.play()
	velocity = Vector2(0, 0)
	collision_layer = 0
	collision_mask = 0
	frogStateMachine.current_state = deathState
	
	

func _on_animated_sprite_2d_animation_finished():
	if anim.animation == "Death":
		var mobs = get_parent()
		if mobs.get_children().size() == 1:
			get_tree().change_scene_to_file("res://Game/world.tscn")
		else:
			queue_free()

