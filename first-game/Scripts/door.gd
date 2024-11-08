extends Area2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var next_scene_path : String = ""
var can_go_through = false
	
func _physics_process(_delta: float) -> void:
	if can_go_through:
		if Input.is_action_just_pressed("enter_door"):
			get_tree().change_scene_to_file(next_scene_path)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		can_go_through = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		can_go_through = false
