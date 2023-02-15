extends TileMap
class_name LightController

export(PackedScene) var packedLightTile: PackedScene
var light_tiles: Dictionary = {}


func _set_at_position(tile_pos: Vector2, lightTile: LightTile)-> void:
	light_tiles[tile_pos.x][tile_pos.y] = lightTile

func _get_at_position(tile_pos: Vector2)-> LightTile:
	return light_tiles[tile_pos.x][tile_pos.y]
	#(light_tiles.get(tile_pos.x, {})).get(tile_pos.y, null)

func _create_position(tile_pos: Vector2)-> void:
	if !light_tiles.has(tile_pos.x):
		light_tiles[tile_pos.x] = {}
		light_tiles[tile_pos.x][tile_pos.y] = null
	else:
		if !light_tiles[tile_pos.x].has(tile_pos.y):
			light_tiles[tile_pos.x][tile_pos.y] = null

func _has_position(tile_pos: Vector2)-> bool:
	if light_tiles.has(tile_pos.x):
		if light_tiles[tile_pos.x].has(tile_pos.y):
			return true
	return false

func _delete_position(tile_pos: Vector2)-> void:
	if light_tiles.has(tile_pos.x):
		if light_tiles[tile_pos.x].has(tile_pos.y):
			light_tiles[tile_pos.x].erase(tile_pos.y)


func create_light(tile_pos: Vector2)-> LightTile:
	if _has_position(tile_pos):
		return null
	_create_position(tile_pos)
	var lightTile: LightTile = packedLightTile.instance()
	add_child(lightTile)
	_set_at_position(tile_pos, lightTile)
	lightTile.set_tile_position(tile_pos)
	return lightTile

func delete_light(tile_pos: Vector2)-> void:
	var lightTile: LightTile = _get_at_position(tile_pos)
	lightTile.queue_free()
	_delete_position(tile_pos)

func clear_lights()-> void:
	for x in light_tiles.keys():
		for y in light_tiles[x].keys():
			delete_light(Vector2(x,y))
