extends Node2D
class_name UnitLogger

export(PackedScene) var packedPlayer: PackedScene 
export(PackedScene) var packedDummy: PackedScene 
onready var turn: int = 0
onready var turn_order: int = -1
onready var units: Array = []
onready var packedUnits: Dictionary = {
	"player": packedPlayer,
	"dummy": packedDummy,
}

func _ready() -> void:
	load_units()

func load_units()-> void:
	var _unit = create_unit_at_pos("player", Vector2(5,5))
	_unit = create_unit_at_pos("dummy", Vector2(6,5))
	next_turn_order()

func next_turn_order()-> void:
	var unit_count: int = units.size()
	if unit_count == 0:
		return
	turn_order = (turn_order + 1) % unit_count
	play_unit_turn(turn_order)

func play_unit_turn(_turn_order: int)-> void:
	units[_turn_order].play_turn()


func create_unit_at_pos(unit_name: String, tile_pos: Vector2)-> Node2D:
	var unit: Node2D = create_unit(unit_name)
	if unit:
		unit.set_tile_position(tile_pos)
	return unit

func create_unit(unit_name: String)-> Node2D:
	var packedUnitScene: PackedScene = packedUnits.get(unit_name, null)
	if !packedUnitScene:
		return null
	var unit: Node2D = packedUnitScene.instance()
	_add_unit(unit)
	return unit

func _add_unit(unit: Node2D)-> void:
	add_child(unit)
	units.append(unit)
	var _err = unit.connect("free_self", self, "_remove_unit")

func _remove_unit(unit: Node2D)-> void:
	units.erase(unit)
	unit.queue_free()

func get_all_unit_positions()-> PoolVector2Array:
	var positions: PoolVector2Array = []
	for unit in units:
		positions.append(unit.get_to_tile())
	return positions

func get_unit_at_tile_pos(tile_pos: Vector2)-> Node2D:
	for unit in units:
		if (tile_pos == unit.get_to_tile()):
			return unit
	return null

func is_unit_at_tile_pos(tile_pos: Vector2)-> bool:
	return (get_unit_at_tile_pos(tile_pos) != null)


#var c = 0
#func _process(delta: float) -> void:
#	c += 1
#	if (c % 60 == 0):
#		pass
#		#print(get_all_unit_positions())
#		#print(is_unit_at_tile_pos(Vector2(3,4)))
