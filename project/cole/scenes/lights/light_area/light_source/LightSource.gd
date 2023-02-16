extends Node2D
class_name LightSource

onready var lightController: LightController = get_tree().get_nodes_in_group("lightController").front()

var lights: Array = []
var tile_position: Vector2 = Vector2.ONE

func set_tile_position(tile_pos: Vector2)-> void:
	tile_position = tile_pos
	update_lights()

func update_lights()-> void:
	if !lightController:
		return
	clear_lights()

func clear_lights()-> void:
	for light in lights:
		delete_light(light)
	lights.clear()

func create_light(tile_pos: Vector2)-> LightTile:
	var light: LightTile =  lightController.create_light(tile_pos)
	_add_light(light)
	return light

func delete_light(light: LightTile)-> void:
	lightController.delete_light(light)
	lights.erase(lights)

func delete_light_at_pos(tile_pos: Vector2)-> void:
	var light: LightTile = _get_light_at_tile(tile_pos)
	if light:
		delete_light(light)



func _get_light_at_tile(tile_pos: Vector2)-> LightTile:
	for light in lights:
		if light.get_tile_position() == tile_pos:
			return light
	return null

func _add_light(light: LightTile)-> void:
	lights.append(light)

func _add_lights(lights: Array)-> void:
	for light in lights:
		_add_light(light)




