extends Control

@onready var package_panel = $VBoxContainer/PackagePanel
@onready var icon_list = $VBoxContainer/PackagePanel/PackageCounter/Icons
@onready var phase_panel = $VBoxContainer/PhasePanel
@onready var phase_label = $VBoxContainer/PhasePanel/Phase
@onready var crate_icon = preload("res://src/HUD/crate_icon.tscn")

var package_number
var current_package = 0

var mouse_in_left   = false
var mouse_in_right  = false
var mouse_in_top    = false
var mouse_in_bottom = false

func _ready():
	self.package_panel.modulate.a = 0
	phase_panel.modulate.a = 0

func init(package_number):
	self.package_number = package_number
	for i in range(package_number):
		var crate_icon_instance = crate_icon.instantiate()
		icon_list.add_child(crate_icon_instance)
	
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_property(phase_panel, "modulate:a", 1, 1.0)

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
	tween.tween_property(phase_panel, "modulate:a", 0, 0.5)
	tween.tween_callback(func(): phase_label.text = "CHALLENGE PHASE")
	tween.parallel().tween_property(phase_panel, "modulate:a", 1.0, 2.0)
	tween.parallel().tween_property(package_panel, "modulate:a", 1.0, 2.0)
