extends Control

@onready var tool_list = $ToolList
@onready var tool_ui_scene = preload("res://src/HUD/tool_ui.tscn")
@onready var map = $"../../Map"

# Called when the node enters the scene tree for the first time.
func _ready():
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
	tool_list.add_child(tool_instance)
	tool_instance.init(tool_template)

