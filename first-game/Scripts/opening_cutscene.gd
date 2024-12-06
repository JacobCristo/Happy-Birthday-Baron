extends Control

@onready var label: Label = $Label
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
const TITLE_SCENE = preload("res://Scenes/title.tscn")

func _ready() -> void:
	get_tree().create_timer(5).timeout.connect(
		func():
			label.visible = false
	)
	video_stream_player.finished.connect(
		func():
			get_tree().change_scene_to_packed(TITLE_SCENE)
	)

func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		get_tree().change_scene_to_packed(TITLE_SCENE)
