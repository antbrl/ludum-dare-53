extends Control

var current_level_number = 0

var current_player: AudioStreamPlayer
var current_scene : set = set_scene

@onready var main_menu = preload("res://src/MainMenu/MainMenu.tscn")
@onready var select_level = preload("res://src/SelectLevel/select_level.tscn")
@onready var game = preload("res://src/Game/Game.tscn")
@onready var change_level = preload("res://src/EndLevel/EndLevel.tscn")
@onready var credits = preload("res://src/Credits/Credits.tscn")
@onready var game_over = preload("res://src/GameOver/GameOver.tscn")

@onready var viewport = $SubViewportContainer/SubViewport

@export var maps: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	_run_main_menu()


func _process(_delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()


func _on_quit_game():
	get_tree().quit()


func _on_start_game():
	_load_level()

func _on_select_level():
	_run_select_level()

func _on_show_credits():
	_run_credits(true)


func _on_show_main_menu():
	_run_main_menu()


func set_scene(new_scene):
	if current_scene:
		viewport.remove_child(current_scene)
		current_scene.queue_free()

	current_scene = new_scene
	viewport.add_child(current_scene)

func _load_level():
	var scene = game.instantiate()
	
	scene.init(current_level_number, maps[current_level_number])

	scene.connect("end_of_level", Callable(self, "_on_end_of_level"))
	scene.connect("game_over", Callable(self, "_on_game_over"))

	self.current_scene = scene


func _on_end_of_level(total_crates, hit_crates, remaining_tools, challenge_time):
	_load_end_level(total_crates, hit_crates, remaining_tools, challenge_time)


func first_level():
	return current_level_number == 0


func _on_game_over():
	var scene = game_over.instantiate()

	scene.connect("restart", Callable(self, "_on_restart_level"))
	scene.connect("quit", Callable(self, "_on_quit_game"))

	self.current_scene = scene


func _on_restart_level():
	_load_level()


func _on_restart_select_level():
	_load_end_level(0, 0, 0, 0)


func _load_end_level(total_crates, hit_crates, remaining_tools, challenge_time):
	var scene = change_level.instantiate()
	scene.init(current_level_number, total_crates, hit_crates, remaining_tools, challenge_time)
	scene.connect("next_level", Callable(self, "_on_next_level"))
	self.current_scene = scene


func _on_next_level():
	if current_level_number + 1 >= len(maps):
		# Win
		_run_credits(false)
	else:
		current_level_number += 1
		_load_level()

func _run_credits(can_go_back):
	var scene = credits.instantiate()

	scene.set_back(can_go_back)
	if can_go_back:
		scene.connect("back", Callable(self, "_on_show_main_menu"))

	self.current_scene = scene


func _run_main_menu():
	var scene = main_menu.instantiate()

	scene.connect("start_game", Callable(self, "_on_start_game"))
	scene.connect("select_level", Callable(self, "_on_select_level"))
	scene.connect("quit_game", Callable(self, "_on_quit_game"))
	scene.connect("show_credits", Callable(self, "_on_show_credits"))

	self.current_scene = scene

func _run_select_level():
	var scene = select_level.instantiate()
	
	scene.init(len(maps))
	scene.connect("level_selected", Callable(self, "_on_level_selected"))
	scene.connect("back", Callable(self, "_run_main_menu"))

	self.current_scene = scene

func _on_level_selected(level):
	current_level_number = level - 1
	_on_next_level()
