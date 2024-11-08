extends CharacterBody2D
class_name Player

@export var RUN_SPEED = 130.0
@export var WALK_SPEED = 45.0
@export var JUMP_VELOCITY = -400.0
var air_jumps = 4 
var has_used_jumps = false
var current_jumps = 0
var bat_smoke_done = false
var fall_smoke_done = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if !is_on_floor():
		velocity += get_gravity() * delta
	else: 
		current_jumps = 0
		has_used_jumps = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		bat_smoke_done = false
		fall_smoke_done = false
		velocity.y = JUMP_VELOCITY
		current_jumps += 1
	elif Input.is_action_just_pressed("jump") and !is_on_floor() and !has_used_jumps:
		if current_jumps == 0:
			velocity.y = JUMP_VELOCITY/1.5
			current_jumps += 2
		elif current_jumps <= air_jumps:
			velocity.y = JUMP_VELOCITY/1.5
			current_jumps += 1
		else:
			has_used_jumps = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		elif Input.is_action_pressed("run"):
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("walk")
	#IF YOU'RE NOT ON THE FLOOR:
	else:
		#IF START FLYING, PLAY SMOKE
		if current_jumps == 2 and !bat_smoke_done:
			animated_sprite_2d.play("bat_smoke")
			animated_sprite_2d.connect("animation_finished", func(): bat_smoke_done = true)
		#ELSE, FLY NORMALLY
		elif current_jumps >= 2 and current_jumps <= air_jumps:
			animated_sprite_2d.play("fly")
		elif current_jumps > air_jumps and !fall_smoke_done:
			animated_sprite_2d.play("fall_smoke")
			animated_sprite_2d.connect("animation_finished", func(): fall_smoke_done = true)
		else: 
			animated_sprite_2d.play("fall")
		
	if Input.is_action_pressed("run"):
		if direction:
			velocity.x = direction * RUN_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, RUN_SPEED)
	else:
		if direction:
			velocity.x = direction * WALK_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
	

	move_and_slide()
