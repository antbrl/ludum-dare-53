extends Node2D

signal tool_built(tool: Globals.Tool, pos: Vector2i, metadata: Dictionary)
signal tool_destroyed(tool: Globals.Tool, pos: Vector2i)

@onready var tool_ghost = $ToolGhost
@onready var tile_map = $TileMap
@onready var launch_area = $Launch
@onready var tools = $Tools

@onready var Trampoline = preload("res://src/Trampoline/trampoline.tscn")

var mode = Globals.DEFAULT_MODE
var current_tool = Globals.DEFAULT_TOOL

var tools_instances := Dictionary()

func _ready():
	launch_area.init($Crates/Crate)

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("build"):
		if mode == Globals.Mode.CONSTRUCTION:
			tile_map.try_build_at_mouse(current_tool)
	elif event.is_action_pressed("destroy"):
		if mode == Globals.Mode.CONSTRUCTION:
			tile_map.try_destroy_at_mouse()

func switch_mode(_mode: Globals.Mode):
	mode = _mode
	tool_ghost.visible = mode == Globals.Mode.CONSTRUCTION


func _on_tile_map_build_tool(tool, pos, metadata):
	print('build tool %d, pos (%d, %d), dir %d' % [tool, pos.x, pos.y, metadata.direction])
	var tool_instance: Node2D = null
	match tool:
#		Globals.Tool.PORTAL:
		Globals.Tool.TRAMPOLINE:
			tool_instance = Trampoline.instantiate()
	if tool_instance == null:
		return
	tool_instance.position = tile_map.map_to_local(pos) * tile_map.scale
	if tools_instances.has(pos):
		tools_instances[pos].queue_free()
	tools_instances[pos] = tool_instance
	tools.add_child(tool_instance)
	
	emit_signal("tool_built", tool, pos, metadata)
	tool_ghost.update()

func _on_tile_map_destroy_tool(tool, pos):
	print('build tool %d, pos (%d, %d)' % [tool, pos.x, pos.y])
	if tools_instances.has(pos):
		tools_instances[pos].queue_free()
		tools_instances.erase(pos)
		
		emit_signal("tool_destroyed", tool, pos)
		tool_ghost.update()
