extends Button

signal tool_selected(tool_template)

var tool_template
var quantity

@onready var tool_texture = $ToolTexture
@onready var quantity_label = $Quantity

# Called when the node enters the scene tree for the first time.
func init(tool_template, quantity):
	self.tool_template = tool_template
	self.tool_texture.texture = self.tool_template.get_texture()
	self.tooltip_text = self.tool_template.get_tool_name()
	update_quantity(quantity)

func update_quantity(quantity):
	self.quantity = quantity
	self.quantity_label.set_text(str(self.quantity))

func _on_pressed():
	emit_signal("tool_selected", self.tool_template)
