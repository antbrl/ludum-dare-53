extends Control

@onready var level_label = $VBoxContainer/VBoxContainer/LevelNumber/LevelNumberValue
@onready var package_counter = $VBoxContainer/VBoxContainer/PackageCounter
@onready var icon_list = $VBoxContainer/VBoxContainer/PackageCounter/Icons
@onready var crate_icon = preload("res://src/HUD/crate_icon.tscn")

var package_number
var current_package = 0

func _ready():
	self.package_counter.modulate.a = 0

func init(level_number, package_number):
	level_label.text = str(level_number + 1)
	self.package_number = package_number
	for i in range(package_number):
		var crate_icon_instance = crate_icon.instantiate()
		icon_list.add_child(crate_icon_instance)

func hit():
	var icon = icon_list.get_child(current_package)
	icon.get_node("Hit").visible = true
	current_package += 1

func miss():
	var icon = icon_list.get_child(current_package)
	icon.get_node("Miss").visible = true
	current_package += 1

func go_to_challenge_phase():
	var tween = create_tween()
	tween.tween_property(package_counter, "modulate:a", 1.0, 2.0)
