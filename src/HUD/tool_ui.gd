extends Button

signal tool_selected

var tool_template
@onready var tool_texture = $ToolTexture

# Called when the node enters the scene tree for the first time.
func init(tool_template):
	self.tool_template = tool_template
	tool_texture.texture = tool_template.get_texture()
	self.tooltip_text = tool_template.get_tool_name()
