extends CharacterBody2D

enum State {PATROL, CHASE}
var state = State.PATROL

const PATROL_SPEED = 30.0
const CHASE_SPEED = 75.0
const JUMP_VELOCITY = -400.0

var direction = 1 #either 1 or -1
var is_paused = false
var player_detected = false
var chase_pause = true

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var sprite: AnimatedSprite2D = $Cultists
@onready var ledge_detector: RayCast2D = $LedgeDetector
@onready var wall_detector: RayCast2D = $WallDetector
@onready var sightbox: Area2D = $Sightbox
@onready var alert_symbol: Sprite2D = $AlertSymbol

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if !is_on_floor():
		velocity += get_gravity() * delta
	
	if direction < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if not is_paused:
		move()
		move_and_slide()

func move():
	if state == State.CHASE:
		if not chase_pause:
			
			var new_direction = sign(player.position.x - position.x)
			
			if not ledge_detector.is_colliding():
				if new_direction != direction:
					direction = new_direction
					flip_raycasts()
				else:
					velocity.x = 0
					return
				
			if new_direction != direction:
				direction = new_direction
				flip_raycasts()
			
			if wall_detector.is_colliding():
				velocity.x = 0
			else:
				velocity.x = direction * CHASE_SPEED
		else:
			velocity.x = 0
		
	elif state == State.PATROL:
		if wall_detector.is_colliding() or not ledge_detector.is_colliding():
			if not is_paused:
				turn_around()
		velocity.x = direction * PATROL_SPEED
	
func turn_around():
	# Stop movement briefly
	is_paused = true
	direction *= -1 # Reverse direction
	velocity.x = 0
	flip_raycasts()
	get_tree().create_timer(0.5).timeout.connect( 
		func(): 
			is_paused = false
	)

func _on_sightbox_body_entered(body: Node2D) -> void:
	if body == player:
		alert_symbol.visible = true
		get_tree().create_timer(0.5).timeout.connect(
			func():
				chase_pause = false
				alert_symbol.visible = false
				player_detected = true
				state = State.CHASE
		)

func _on_sightbox_body_exited(body: Node2D) -> void:
	if body == player:
		player_detected = false
		state = State.PATROL

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		body.die()
		
func flip_raycasts():
	wall_detector.target_position.x *= -1
	ledge_detector.position.x *= -1
