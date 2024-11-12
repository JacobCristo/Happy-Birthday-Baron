#FAKE LOADING SCREEN

#goes slow so the user can see it for more than a single frame since nothing is very 
#intensive in terms of loading in this game

extends Control

@onready var baron_bar: AnimatedSprite2D = $BarPath/PathFollow2D/BaronBar
@onready var bar_path: Path2D = $BarPath
@onready var path_follow: PathFollow2D = $BarPath/PathFollow2D
@onready var timer: Timer = $Timer
@onready var progress_number: Label = $ProgressNumber

var base_bar_speed = 400

func _process(delta: float) -> void:
	
	if path_follow.progress_ratio == 1:
		if timer.is_stopped():
			timer.start()
		
	var bar_speed = randf_range(0.5, 1.5) * base_bar_speed
	path_follow.progress += bar_speed * delta
	#snapped rounds the number to the closest amount of the second. 0.5555 -> 0.55 (55 * 0.01)
	progress_number.text = str(snapped(path_follow.progress_ratio * 100, 0.01)) + "%"

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file(Globals.next_scene)
	
#REAL LOADING SCENE CODE
#extends Control
#
#@onready var baron_bar: AnimatedSprite2D = $BarPath/PathFollow2D/BaronBar
#@onready var bar_path: Path2D = $BarPath
#@onready var path_follow: PathFollow2D = $BarPath/PathFollow2D
#@onready var timer: Timer = $Timer
#@onready var progress_number: Label = $ProgressNumber
#
#var base_bar_speed = 400
#
#func _ready():
	#ResourceLoader.load_threaded_request(Globals.next_scene)
#
#func _process(_delta: float) -> void:
	#var progress = []
	#
	#ResourceLoader.load_threaded_get_status(Globals.next_scene, progress)
	#path_follow.progress = progress[0] * 100
	#
	##snapped rounds the number to the closest amount of the second. 0.5555 -> 0.55 (55 * 0.01)
	#progress_number.text = str(snapped(path_follow.progress_ratio * 100, 0.01)) + "%"
	#
	#if progress[0] == 1:
		#var packed_scene = ResourceLoader.load_threaded_get(Globals.next_scene)
		#get_tree().change_scene_to_packed(packed_scene)
