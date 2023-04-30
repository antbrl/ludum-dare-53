extends Control

@onready var tool_list = $ToolList
@onready var tool_ui_scene = preload("res://src/HUD/tool_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_tool_templates_new_tool(tool_template):
	var tool_instance = tool_ui_scene.instantiate()
	tool_list.add_child(tool_instance)
	tool_instance.init(tool_template)
