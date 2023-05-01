extends Node2D

class_name Map

signal tool_built(tool_slot: InventorySlot, pos: Vector2i, metadata: Dictionary, quantity: int)
signal tool_destroyed(tool_slot: InventorySlot, pos: Vector2i, quantity: int)
signal mode_to_construction()

@onready var tool_ghost = $ToolGhost
@onready var tile_map = $TileMap
@onready var launch_area = $Launch
@onready var tools = $Tools
@onready var level = $".."
@onready var target = $Target
@onready var camera = $Camera2D

@onready var Trampoline = preload("res://src/Tool/Trampoline/trampoline.tscn")
@onready var Portal = preload("res://src/Tool/Portal/Portal.tscn")
@onready var singularity = preload("res://src/Tool/Singularity/Singularity.tscn")
@onready var Vacuum = preload("res://src/Tool/Vacuum/Vacuum.tscn")
@onready var Belt = preload("res://src/Tool/Belt/Belt.tscn")

@export var inventory: Array[InventorySlot]
@export var n_challenge_crates: int
@export var level_name: String

var mode = Globals.DEFAULT_MODE:
	set(value):
		mode = value
		tile_map.update_tool_overlay(mode, current_tool)

var current_tool = Globals.DEFAULT_TOOL:
	set(value):
		current_tool = value
		tile_map.update_tool_overlay(mode, current_tool)

var tools_instances := Dictionary()

func update_tool(tool_template: ToolTemplate):
	current_tool = tool_template.tool_id
	tool_ghost.tool_changed(tool_template.texture)

func _ready():
	assert(n_challenge_crates > 0, "negative n_challenge_crates")

func _process(delta):
	pass

func is_mouse_on_ui():
	for c in get_node("../UI/ActionUI/ActionBar/ToolList").get_children():
		if c.is_hovered():
			return true
	for c in get_node("../UI/ActionUI/ActionBar/ButtonBar").get_children():
		if c is Button && c.is_hovered():
			return true
	return false

func _input(event):
	if event.is_action_pressed("build"):
		if is_mouse_on_ui():
			return
		for slot in inventory:
			if mode == Globals.Mode.CONSTRUCTION and slot.tool_id == current_tool:
				tile_map.try_build_at_mouse(current_tool, slot.quantity)
	elif event.is_action_pressed("destroy"):
		if mode == Globals.Mode.CONSTRUCTION:
			tile_map.try_destroy_at_mouse()

func switch_mode(_mode: Globals.Mode):
	mode = _mode
	if (_mode == Globals.Mode.CONSTRUCTION):
		launch_area.set_disabled_mode(true)
		tool_ghost.visible = true
	elif (_mode == Globals.Mode.CINEMATIC):
		launch_area.set_disabled_mode(true)
		tool_ghost.visible = false
		camera.cinematic_view_to($Target)
	else:
		launch_area.set_disabled_mode(false)
		tool_ghost.visible = false

func _on_tile_map_build_tool(tool, pos, metadata):
	var tool_instance: Node2D = null
	match tool:
		Globals.Tool.PORTAL:
			tool_instance = Portal.instantiate()
			tool_instance.direction = metadata.direction
		Globals.Tool.TRAMPOLINE:
			tool_instance = Trampoline.instantiate()
			tool_instance.direction = metadata.direction
		Globals.Tool.SINGULARITY:
			tool_instance = singularity.instantiate()
		Globals.Tool.BELT:
			tool_instance = Belt.instantiate()
			tool_instance.direction = metadata.direction
		Globals.Tool.VACUUM:
			tool_instance = Vacuum.instantiate()
			tool_instance.direction = metadata.direction
		_:
			assert(false, 'Missing tool')
	if tool_instance == null:
		return
	tool_instance.position = tile_map.map_to_local(pos) * tile_map.scale
	if tools_instances.has(pos):
		tools_instances[pos].queue_free()
	tools_instances[pos] = tool_instance
	tools.add_child(tool_instance)
	
	tool_ghost.update()
	tile_map.update_tool_overlay(mode, current_tool)
	
	for slot in inventory:
		if slot.tool_id == tool:
			slot.quantity -= 1
			emit_signal("tool_built", slot, pos, metadata)

func _on_tile_map_destroy_tool(tool, pos):
	if tools_instances.has(pos):
		tools_instances[pos].queue_free()
		tools_instances.erase(pos)
		
		tool_ghost.update()
		tile_map.update_tool_overlay(mode, current_tool)

		for slot in inventory:
			if slot.tool_id == tool:
				slot.quantity += 1
				emit_signal("tool_destroyed", slot, pos)


func _on_back_to_default_timeout():
	emit_signal("mode_to_construction")

func reset_crates():
	launch_area.interrupt()

func reset_tools():
	tile_map.destroy_all_tools()


func _on_tile_map_update_tool(tool, pos, metadata):
	if tools_instances.has(pos):
		tools_instances[pos].direction = metadata.direction
		
#		tool_ghost.update()
#		tile_map.update_tool_overlay(mode, current_tool)
