extends Node

@onready var music_players = get_children() as Array[AudioStreamPlayer]
var current_player_index = 0

func _ready():
	_start_current_track()

func _on_music_finished():
	current_player_index = (current_player_index + 1) % len(music_players)
	_start_current_track()

func _start_current_track():
	music_players[current_player_index].play()
