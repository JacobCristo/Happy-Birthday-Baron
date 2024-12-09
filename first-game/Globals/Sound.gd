extends Node

@export var players_size = 16

@export_group("sounds")
@export var WALK := preload("res://Assets/sounds/walking.mp3")

var players: Array[AudioStreamPlayer] 
var current_player_index = 0

func _ready() -> void:
	players.resize(players_size)
	for i in players_size:
		var player:= AudioStreamPlayer.new()
		players[i] = player
		add_child(player)

func play(sound: AudioStream):
	if players[current_player_index].playing == true:
		players[current_player_index].stop()
		
	else:
		players[current_player_index].stream = sound
		players[current_player_index].play()
		current_player_index += (current_player_index + 1) % players_size

func walk():
	play(WALK)
