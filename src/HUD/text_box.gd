extends Control

signal popup_closed

@onready var title = $PanelContainer/VBoxContainer/Title
@onready var text = $PanelContainer/VBoxContainer/Text

func _ready():
	visible = false

func pop_text_box(title: String, text: String):
	visible = true
	self.title.text = title
	self.text.text = text

func _on_gui_input(event):
	if event is InputEventMouseButton:
		visible = false
		emit_signal("popup_closed")
