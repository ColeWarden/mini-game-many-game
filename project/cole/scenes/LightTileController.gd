extends Node2D
class_name LightController

signal lights_at_tile_pos(lights_array, tile_pos)

onready var pooled_lights: Array = []

export(PackedScene) var packedLightTile: PackedScene
var light_tiles: Dictionary = {}

func _get_light_position(lightTile: LightTile)-> Vector2:
	return lightTile.get_tile_position()

func _set_at_position(tile_pos: Vector2, lightTile: LightTile)-> void:
	light_tiles[tile_pos.x][tile_pos.y].append(lightTile)

func _get_at_position(tile_pos: Vector2)-> Array:
	return light_tiles[tile_pos.x][tile_pos.y]
	#(light_tiles.get(tile_pos.x, {})).get(tile_pos.y, null)

func _create_position(tile_pos: Vector2)-> void:
	if !light_tiles.has(tile_pos.x):
		light_tiles[tile_pos.x] = {}
		light_tiles[tile_pos.x][tile_pos.y] = []
	else:
		if !light_tiles[tile_pos.x].has(tile_pos.y):
			light_tiles[tile_pos.x][tile_pos.y] = []

func _has_light(tile_pos: Vector2, light: LightTile)-> bool:
	if light_tiles.has(tile_pos.x):
		if light_tiles[tile_pos.x].has(tile_pos.y):
			return light_tiles[tile_pos.x][tile_pos.y].has(light)
	return false

func _clean_position(tile_pos: Vector2)-> void:
	if light_tiles[tile_pos.x][tile_pos.y].empty():
		var _err = light_tiles[tile_pos.x].erase(tile_pos.y)
		if light_tiles[tile_pos.x].empty():
			_err = light_tiles.erase(tile_pos.x)

func _create_light(tile_pos: Vector2, light: LightTile)-> void:
	_create_position(tile_pos)
	light_tiles[tile_pos.x][tile_pos.y].append(light)

func _delete_light(tile_pos: Vector2, light: LightTile)-> void:
	if _has_light(tile_pos, light):
		light_tiles[tile_pos.x][tile_pos.y].erase(light)
		_clean_position(tile_pos)


func _emit_lights_at_tile_pos(tile_pos: Vector2)-> void:
	var light_array: Array = []
	if light_tiles.get(tile_pos.x, {}):
		var d: Dictionary = light_tiles.get(tile_pos.x, {})
		if !d.empty():
			light_array = d.get(tile_pos.y, [])
	emit_signal("lights_at_tile_pos", light_array, tile_pos)

func create_light(tile_pos: Vector2)-> LightTile:
	var light: LightTile = fetch_pooled_light()
	_create_light(tile_pos, light)
	light.set_tile_position(tile_pos)
	return light

func delete_light(light: LightTile)-> void:
	var tile_pos: Vector2 = _get_light_position(light)
	_delete_light(tile_pos, light)
	pooled_lights.append(light)
	light.visible = false

func set_light_mode(light: LightTile, light_mode: int)-> void:
	light._set_light_mode(light_mode)
	var tile_pos: Vector2 = light.get_tile_position()
	_emit_lights_at_tile_pos(tile_pos)

func fetch_pooled_light()-> LightTile:
	var light: LightTile
	if pooled_lights.empty():
		light = packedLightTile.instance()
		add_child(light)
		return light
	light = pooled_lights.pop_back()
	light.visible = true
	return light

func clear_lights(lights: Array)-> void:
	for light in lights:
		delete_light(light)

func clear()-> void:
	for x in light_tiles.keys():
		for y in light_tiles[x].keys():
			for light in light_tiles[x][y]:
				delete_light(light)
