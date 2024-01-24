extends State

@export var anim : AnimatedSprite2D
@export var frog : CharacterBody2D
@export var aggroAudio : AudioStreamPlayer2D
@export var jumpAudio : AudioStreamPlayer2D

var jumping = false
var jump_speed = -250
var jump_timer = 0
var right : bool

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func Enter():
	right = anim.flip_h
	anim.play("Aggro")
	aggroAudio.play()

func Physics_Update(delta):
	if jumping:
		# air resistance
		frog.velocity.x *= 0.99

		# jump
		jump_timer += delta
		if jump_timer > 0.5:
			stop_jump()
			return
		else:
			frog.move_and_slide()
		
		if frog.is_on_floor():
			stop_jump()
			return
		
		# falling
		if frog.velocity.y > 0:
			anim.play("Fall")
		# floating
		elif frog.velocity.y < 0:
			anim.play("Jump")

func start_jump():
	jumping = true
	frog.velocity.y = jump_speed  # Apply initial jump speed
	if right:
		frog.velocity.x = 100
	else:
		frog.velocity.x = -100
	jumpAudio.play()

func stop_jump():
	jumping = false
	jump_timer = 0
	frog.velocity.y = 0
	frog.velocity.x = 0
	Transitioned.emit(self, "FrogIdle")

func _on_animated_sprite_2d_animation_finished():
	if anim.animation == "Aggro":
		start_jump()
