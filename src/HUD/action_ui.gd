extends Control

signal mode_change(mode: Globals.Mode)

@onready var tool_list = $ToolList
@onready var tool_ui_scene = preload("res://src/HUD/tool_ui.tscn")
@onready var level = $"../.."
@onready var map = $"../../Map"
@onready var switch_mode_button = $SwitchModeButton

var mode = Globals.DEFAULT_MODE

# Called when the node enters the scene tree for the first time.
func _ready():
	tool_list.visible = mode == Globals.Mode.CONSTRUCTION
	map.connect("tool_built", _tool_built)
	map.connect("tool_destroyed", _tool_destroyed)

func _tool_built(tool, _pos, _metadata):
	for tool_ui in tool_list.get_children():
		tool_ui.update()

func _tool_destroyed(tool, _pos):
	for tool_ui in tool_list.get_children():
		tool_ui.update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init(templates):
	for tool_template in templates:
		add_tool(tool_template)

func add_tool(tool_template):
	var tool_instance = tool_ui_scene.instantiate()
	tool_instance.connect("tool_selected", level._on_tool_selected)
	tool_list.add_child(tool_instance)
	tool_instance.init(tool_template)

func _on_switch_mode_button_pressed():
	if mode == Globals.Mode.THROW:
		switch_mode(Globals.Mode.CONSTRUCTION)
	else:
		switch_mode(Globals.Mode.THROW)

func switch_mode(mode: Globals.Mode):
	self.mode = mode
	tool_list.visible = mode == Globals.Mode.CONSTRUCTION

	if mode == Globals.Mode.THROW:
		switch_mode_button.text = 'Construction mode'
	else:
		switch_mode_button.text = 'Throw mode'
	emit_signal("mode_change", mode)
