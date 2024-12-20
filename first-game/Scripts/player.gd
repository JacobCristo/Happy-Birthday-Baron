extends CharacterBody2D
class_name Player

@export var RUN_SPEED = 130.0
@export var WALK_SPEED = 45.0
@export var JUMP_VELOCITY = -400.0
var air_jumps = 4 
var current_jumps = 0
var has_used_jumps = false
var bat_smoke_done = false
var fall_smoke_done = false
var transitioning = false
var dying = false

var walk := preload("res://Assets/sounds/walking.mp3")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var audio: AudioStreamPlayer = $Audio

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
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	if is_on_floor() and !transitioning:
		if direction == 0:
			sprite.play("idle")
		elif Input.is_action_pressed("run"):
			sprite.play("run")
		else:
			audio.stream = walk
			audio.play()
			sprite.play("walk")
			
	#IF YOU'RE NOT ON THE FLOOR:
	elif !is_on_floor() and !transitioning:
		#if Input.is_action_just_pressed("jump"):
			#audio.stream = jump
			#audio.play()
		
		#if audio.stream == walk or audio.stream == run:
			#audio.stop()
		
		#IF START FLYING, PLAY SMOKE
		if current_jumps == 2 and !bat_smoke_done:
			sprite.play("bat_smoke")
			sprite.connect("animation_finished", func(): bat_smoke_done = true)
		#ELSE, FLY NORMALLY
		elif current_jumps >= 2 and current_jumps <= air_jumps:
			sprite.play("fly")
		elif current_jumps > air_jumps and !fall_smoke_done:
			sprite.play("fall_smoke")
			sprite.connect("animation_finished", func(): fall_smoke_done = true)
		else: 
			sprite.play("fall")
		
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

func die():
	if not dying:
		velocity.y = -400.0
		Engine.time_scale = 0.5
		get_tree().create_timer(0.5).timeout.connect( 
			func():
				queue_free()
				Engine.time_scale = 1
				get_tree().reload_current_scene()
				)
