extends Button

signal tool_selected

var tool_template
@onready var tool_texture = $ToolTexture
@onready var quantity = $Quantity

# Called when the node enters the scene tree for the first time.
func init(tool_template):
	self.tool_template = tool_template
	update()

func update():
	tool_texture.texture = tool_template.get_texture()
	self.tooltip_text = tool_template.get_tool_name()
	self.quantity.set_text(str(tool_template.get_quantity()))
	visible = tool_template.available
