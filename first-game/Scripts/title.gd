extends Control

@onready var play: Button = $VBoxContainer/Play
@onready var quit: Button = $VBoxContainer/Quit

func _ready() -> void:
	#grab focus for controllers
	#play.grab_focus()
	
	#connect signals for pressing the buttons to play the game or quit the game,
	#depending on the button
	play.connect("pressed", func(): get_tree().change_scene_to_file("res://Scenes/opening.tscn"))	
	quit.connect("pressed", func(): get_tree().quit())
