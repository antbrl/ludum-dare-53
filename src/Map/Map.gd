extends Node2D

class_name Map

signal tool_built(tool_slot: InventorySlot, pos: Vector2i, metadata: Dictionary, quantity: int)
signal tool_destroyed(tool_slot: InventorySlot, pos: Vector2i, quantity: int)

@onready var tool_ghost = $ToolGhost
@onready var tile_map = $TileMap
@onready var launch_area = $Launch
@onready var tools = $Tools
@onready var level = $".."

@onready var Trampoline = preload("res://src/Tool/Trampoline/trampoline.tscn")
@onready var Portal = preload("res://src/Tool/Portal/Portal.tscn")
@onready var singularity = preload("res://src/Tool/Singularity/Singularity.tscn")

@export var inventory: Array[InventorySlot]

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

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("build"):
		for slot in inventory:
			if slot.tool_id == current_tool:
				if slot.quantity <= 0:
					return

		if mode == Globals.Mode.CONSTRUCTION:
			tile_map.try_build_at_mouse(current_tool)
	elif event.is_action_pressed("destroy"):
		if mode == Globals.Mode.CONSTRUCTION:
			tile_map.try_destroy_at_mouse()

func switch_mode(_mode: Globals.Mode):
	mode = _mode
	tool_ghost.visible = mode == Globals.Mode.CONSTRUCTION

func _on_tile_map_build_tool(tool, pos, metadata):
	var tool_instance: Node2D = null
	match tool:
		Globals.Tool.PORTAL:
			tool_instance = Portal.instantiate()
			tool_instance.direction = metadata.direction
		Globals.Tool.TRAMPOLINE:
			tool_instance = Trampoline.instantiate()
		Globals.Tool.SINGULARITY:
			tool_instance = singularity.instantiate()
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
