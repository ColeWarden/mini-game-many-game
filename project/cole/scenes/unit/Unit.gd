extends Node2D
class_name Unit


signal free_self(self_id)
signal move_to_tile(tile_pos)
signal look_to_direction(direction)
signal moves_left(moves_left)
signal out_of_moves()

onready var unitLogger: UnitLogger = get_tree().get_nodes_in_group("unitLogger").front()
onready var tileMapEffect: TileMapEffect = get_tree().get_nodes_in_group("tileMapEffect").front()

var to_tile: Vector2 = Vector2(0,0)
var look_direction: Vector2 = Vector2.DOWN
var move_weight: float = 12.0

var starting_moves: int = 1
var moves_left: int = 1
var costs: Dictionary = {
	"move": 1,
	"look": 1,
}

func _ready()-> void:
	connect("out_of_moves", unitLogger, "next_turn_order")
func play_turn()-> void:
	set_moves_left(starting_moves)

# Moves
func set_starting_moves(_moves: int)-> void:
	starting_moves = int(max(_moves, 0))

func get_starting_moves()-> int:
	return starting_moves

func set_moves_left(_moves_left: int)-> void:
	moves_left = int(max(_moves_left, 0))
	emit_signal("moves_left", moves_left)
	if moves_left == 0:
		emit_signal("out_of_moves")
	print("Moves left: ", moves_left)

func get_moves_left()-> int:
	return moves_left

func sub_moves(value: int)-> void:
	var _moves_left: int = get_moves_left() - value
	set_moves_left(_moves_left)

func has_enough_moves(cost: int)-> bool:
	return (cost <= get_moves_left())

# Movement costs
func add_cost_key(cost_name: String)-> void:
	costs[cost_name] = 0

func delete_cost_key(cost_name: String)-> void:
	if costs.has(cost_name):
		costs.erase(cost_name)

func set_cost(cost_name: String, value: int)-> void:
	costs[cost_name] = value

func get_cost(cost_name: String)-> int:
	if !costs.has(cost_name):
		print("Cost: ", cost_name, " not found")
	var cost: int = costs.get(cost_name, 0)
	return cost


func free_self()-> void:
	emit_signal("free_self", self)


func move(dir: Vector2)-> void:
	if dir == Vector2.ZERO:
		return
	var cardinal_dir: Vector2 = get_cardinal_dir(dir)
	var tile_pos: Vector2 = to_tile + cardinal_dir
	if is_wall_tile(tile_pos):
		return
	if get_unit_at_tile_pos(tile_pos):
		return
	var move_cost: int = get_cost("move")
	if !has_enough_moves(move_cost):
		return
	
	sub_moves(move_cost)
	set_to_tile(tile_pos)


func look(cardinal_dir: Vector2)-> void:
	if (cardinal_dir == Vector2.ZERO) or (look_direction == cardinal_dir):
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

func is_wall_tile(tile_pos: Vector2)-> bool:
	return tileMapEffect.is_wall_tile(tile_pos)

func get_unit_at_tile_pos(tile_pos: Vector2)-> Unit:
	var unit: Unit = unitLogger.get_unit_at_tile_pos(tile_pos)
	return unit

func is_unit_at_tile_pos(tile_pos: Vector2)-> bool:
	return unitLogger.is_unit_at_tile_pos(tile_pos)
