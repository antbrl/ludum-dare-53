extends Control

signal level_selected(level: int)
signal back()

@onready var level_list = $PanelContainer/HBoxContainer/VBoxContainer/LevelList
@onready var level_btn = preload("res://src/SelectLevel/level_button.tscn")

var n_levels

func _ready():
	for i in range(n_levels):
		var level_btn_instance = level_btn.instantiate()
		level_btn_instance.init(i)
		level_btn_instance.connect('level_clicked', self._selected)
		level_list.add_child(level_btn_instance)

func init(n_levels):
	self.n_levels = n_levels

func _selected(level):
	emit_signal("level_selected", level)
	queue_free()

func _on_back_pressed():
	emit_signal("back")
	queue_free()
