extends Node2D
class_name FlashLight

onready var lightController: LightController = get_tree().get_nodes_in_group("lightController").front()
var radius: int = 2


func _update_tile(tile_pos: Vector2)-> void:
	print(tile_pos)
	lightController.clear_lights()
	var surrounding_tiles: PoolVector2Array = get_tiles_around(tile_pos, Vector2(radius, radius))
	print(surrounding_tiles)
	var lightTile: LightTile
	for t_pos in  surrounding_tiles:
		lightTile = lightController.create_light(t_pos)
		lightTile.set_light_mode(lightTile.LIGHT_MODE.TRANSPARENT)


# Vector2(5,3) will get 3 tiles up, down and 5 tiles left and right from tile_pos
func get_tiles_around(tile_pos: Vector2, rect_size: Vector2)-> PoolVector2Array:
	#var origin_position: Vector2 = (global_position / 32.0).snapped(Vector2.ONE)
	#origin_pos = tile_pos * 32.0
	var begin_tile: Vector2 = tile_pos - rect_size
	var end_tile: Vector2 = tile_pos + rect_size
	var _room_size: Vector2 = Vector2(1000, 1000)
	begin_tile.x = int(clamp(begin_tile.x, 0, _room_size.x))
	begin_tile.y = int(clamp(begin_tile.y, 0, _room_size.y))
	end_tile.x = int(clamp(end_tile.x, 0, _room_size.x))
	end_tile.y = int(clamp(end_tile.y, 0, _room_size.y))
	
	var tiles: PoolVector2Array = []
	for x in range(begin_tile.x, end_tile.x+1):
		for y in range(begin_tile.y, end_tile.y+1):
			tiles.append(Vector2(x,y)) 
	return tiles
