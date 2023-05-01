extends Control

@onready var package_counter = $VBoxContainer/PackageCounter
@onready var icon_list = $VBoxContainer/PackageCounter/Icons
@onready var phase = $VBoxContainer/Phase
@onready var crate_icon = preload("res://src/HUD/crate_icon.tscn")

var package_number
var current_package = 0

var mouse_in_left   = false
var mouse_in_right  = false
var mouse_in_top    = false
var mouse_in_bottom = false

func _ready():
	self.package_counter.modulate.a = 0
	phase.modulate.a = 0

	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_property(phase, "modulate:a", 1, 1.0)

func init(package_number):
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
	tween.tween_property(phase, "modulate:a", 0, 0.5)
	tween.tween_callback(func(): phase.text = "CHALLENGE PHASE")
	tween.parallel().tween_property(phase, "modulate:a", 1.0, 2.0)
	tween.parallel().tween_property(package_counter, "modulate:a", 1.0, 2.0)
