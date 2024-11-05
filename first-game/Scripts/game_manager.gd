extends Node

func Quit():
	if Input.is_action_just_pressed("quit"):
		get_tree().quit();
		
func _process(_delta: float) -> void:
	Quit();
