extends Node2D
class_name Unit

signal free_self(self_id)
signal move_to_tile(tile_pos)
signal look_to_direction(direction)

onready var unitLogger: UnitLogger = get_tree().get_nodes_in_group("unitLogger").front()

var to_tile: Vector2 = Vector2(0,0)
var look_direction: Vector2 = Vector2.DOWN
var move_weight: float = 12.0

func _ready() -> void:
	pass

func free_self()-> void:
	emit_signal("free_self", self)

func move(dir: Vector2)-> void:
	if dir == Vector2.ZERO:
		return
	var cardinal_dir: Vector2 = get_cardinal_dir(dir)
	var tile_pos: Vector2 = to_tile + cardinal_dir
	if ("IMPLEMENT TILE DETECTION"):
		set_to_tile(tile_pos)


func look(cardinal_dir: Vector2)-> void:
	if cardinal_dir == Vector2.ZERO:
		return
	look_direction = cardinal_dir
	emit_signal("look_to_direction", cardinal_dir)


func set_tile_position(tile_pos: Vector2)-> void:
	global_position = (tile_pos * 32.0) + Vector2(16,16)
	set_to_tile(tile_pos)


func get_tile_position()-> Vector2:
	return (global_position - Vector2(16,16)) / 32.0


func get_cardinal_dir(dir: Vector2)-> Vector2:
	if (abs(dir.x) > abs(dir.y)): # X mode
		dir.x = sign(dir.x)
		dir.y = 0
	else:
		dir.x = 0
		dir.y = sign(dir.y)
	return dir


func set_to_tile(tile: Vector2)-> void:
	#set_tile_position(tile)
	to_tile = tile
	emit_signal("move_to_tile", to_tile)

func get_to_tile()-> Vector2:
	return to_tile

func _process(delta: float) -> void:
	var global_tile_pos: Vector2 = (to_tile * 32) + Vector2(16,16)
	global_position = global_position.linear_interpolate(global_tile_pos, delta * move_weight)
