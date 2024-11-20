extends Control

@onready var play: Button = $VBoxContainer/Play
@onready var quit: Button = $VBoxContainer/Quit
@onready var fall_area: Area2D = $FallArea
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var first_scene = "res://Scenes/loading_screen.tscn"

var mouse_in_area = false

func _ready() -> void:
	#grab focus for controllers
	#play.grab_focus()
	
	#connect signals for pressing the buttons to play the game or quit the game,
	#depending on the button
	
	play.connect("pressed", func(): get_tree().change_scene_to_file(first_scene))	
	quit.connect("pressed", func(): get_tree().quit())

func _process(_delta: float) -> void:
	if Input.is_action_pressed("left_click") and mouse_in_area:
		sprite.play("titlefall")

func _on_fall_area_mouse_entered() -> void:
	mouse_in_area = true

func _on_fall_area_mouse_exited() -> void:
	mouse_in_area = false
