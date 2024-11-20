extends Area2D

@onready var player = get_tree().get_first_node_in_group("player") as Player
@export var next_scene_path : String = ""

var can_go_through = false
	
func _physics_process(_delta: float) -> void:
	if can_go_through == true:
		if Input.is_action_just_pressed("enter_door"):
			player.transitioning = true
			player.sprite.play("door_transition")
			player.sprite.connect("animation_finished", 
			func(): 
				Globals.next_scene = next_scene_path
				get_tree().change_scene_to_packed(Globals.loading_screen)
				player.transitioning = false
			)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_go_through = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_go_through = false
