extends Control

signal mode_change(mode: Globals.Mode)
signal reset_crate
signal reset_tools

@onready var tool_list = $ToolList
@onready var tool_ui_scene = preload("res://src/HUD/tool_ui.tscn")
@onready var game = $"../.."
@onready var switch_mode_button = $ButtonBar/SwitchModeButton
@onready var reset_crates_button = $ButtonBar/ResetCrateButton
@onready var reset_tools_button = $ButtonBar/ResetToolsButtons

var map

var mode = Globals.DEFAULT_MODE

func init(map):
	self.map = map
	map.connect("tool_built", _tool_built)
	map.connect("tool_destroyed", _tool_destroyed)
	map.connect("mode_to_construction", _on_mode_to_construction)
	switch_mode(Globals.Mode.CINEMATIC)
	
	for slot in self.map.inventory:
		var tool_template = Globals.get_tool_template(slot.tool_id)
		if tool_template != null:
			add_tool(tool_template, slot.quantity)
	switch_mode(mode)

func _tool_built(slot, _pos, _metadata):
	_update_child(slot)

func _tool_destroyed(slot, _pos):
	_update_child(slot)

func _update_child(slot):
	for tool_ui in tool_list.get_children():
		if tool_ui.tool_template.tool_id == slot.tool_id:
			tool_ui.update_quantity(slot.quantity)

func add_tool(tool_template, quantity: int):
	var tool_ui_instance = tool_ui_scene.instantiate()
	tool_ui_instance.connect("tool_selected", game._on_tool_selected)
	tool_list.add_child(tool_ui_instance)
	tool_ui_instance.init(tool_template, quantity)
	if tool_template.tool_id == Globals.DEFAULT_TOOL:
		tool_ui_instance._on_pressed()

func _on_switch_mode_button_pressed():
	if mode == Globals.Mode.THROW:
		switch_mode(Globals.Mode.CONSTRUCTION)
	else:
		switch_mode(Globals.Mode.THROW)

func switch_mode(mode: Globals.Mode):
	self.mode = mode
	match(mode):
		Globals.Mode.THROW:
			switch_button('Switch to construction mode', false)
			reset_crates_button.visible = true
			reset_tools_button.visible = false
			tool_list.visible = false
		Globals.Mode.CONSTRUCTION:
			switch_button('Switch to throw mode', false)
			switch_mode_button.text = 'Switch to throw mode'
			reset_crates_button.visible = false
			reset_tools_button.visible = true
			tool_list.visible = true
		Globals.Mode.CINEMATIC:
			switch_button('Switch to throw mode', true)
			reset_crates_button.visible = false
			reset_tools_button.visible = false
			tool_list.visible = false
		_:
			assert(false, "Unknown mode " + str(mode))

	emit_signal("mode_change", mode)
	
func switch_button(text, disabled):
	switch_mode_button.text = text
	switch_mode_button.disabled = disabled

func go_to_challenge_phase():
	switch_mode(Globals.Mode.THROW)
	switch_mode_button.disabled = true
	
func _on_mode_to_construction():
	switch_mode(Globals.Mode.CONSTRUCTION)
	
func _on_reset_crate_button_pressed():
	emit_signal("reset_crates")

func _on_reset_tools_buttons_pressed():
	emit_signal("reset_tools")
