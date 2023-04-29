extends Node

signal end_of_level
signal game_over

var level_number
var mode = Globals.DEFAULT_MODE

@onready var hud = $UI/HUD
@onready var truck = $Map/Truck
@onready var map = $Map

func _ready():
	assert(
		level_number != null, "init must be called before creating Level scene"
	)
	hud.set_level_number(level_number)
	truck.connect("crate_dropped", end_level)


func init(level_number, nb_coins):
	self.level_number = level_number

func end_level():
	emit_signal("end_of_level")


func _on_hud_mode_change(mode):
	map.switch_mode(mode)
