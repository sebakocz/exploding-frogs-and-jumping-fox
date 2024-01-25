extends CharacterBody2D
class_name Player

signal health_changed

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_HEALTH = 5
const GROUND_FRICTION = 0.2

var infinite_jumps = false
var invincible = false
var knocked_back = false
var health = MAX_HEALTH
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var hurtAudio: AudioStreamPlayer
@export var jumpAudio: AudioStreamPlayer
@export var deathAudio: AudioStreamPlayer

@onready var anim = get_node("AnimationPlayer")
@onready var sprite = get_node("AnimatedSprite2D")

func _physics_process(delta):
	# Handle friction. 
	if not knocked_back:
		velocity.x *= GROUND_FRICTION

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		anim.play("Jump")

	# Handle jump.
	if (
		(Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"))
		and (is_on_floor() or infinite_jumps)
	):
		velocity.y = JUMP_VELOCITY
		jumpAudio.play()

	# Debug - press N
	if Input.is_key_pressed(KEY_N):
		pass

	# Handle movement.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and not knocked_back:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("Run")
	else:
		anim.play("Idle")

	# Handle falling.
	if velocity.y > 0:
		anim.play("Fall")

	# Flip the sprite based on the direction.
	if direction and not knocked_back:
		sprite.flip_h = direction < 0

	move_and_slide()

func damaged():
	# reduce health
	if invincible:
		return
	invincible = true
	health -= 1
	health_changed.emit(health)

	# knock back the player
	knocked_back = true
	velocity.y = JUMP_VELOCITY * 0.75
	velocity.x = -velocity.x * 0.25 + 50 * (1 if sprite.flip_h else - 1)

	# play hurt sound
	hurtAudio.play()

	# flicker the sprite
	var tween = create_tween()
	for i in 3:
		tween.tween_property(self, "modulate", Color.WHITE, .2).from(Color.RED).set_trans(
			Tween.TRANS_QUAD
		)

	if health == 0:
		# disable collision, play lose sound -> change scene
		collision_layer = 0
		collision_mask = 0
		tween.tween_property(self, "modulate", Color.RED, .2).set_trans(Tween.TRANS_QUAD)
		deathAudio.play()
		await get_tree().create_timer(1.8).timeout
		get_tree().change_scene_to_file("res://Game/world.tscn")

	else:
		await tween.finished
		knocked_back = false
		invincible = false
