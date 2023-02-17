extends Node2D
class_name LightLogger


export(PackedScene) var packedCandle: PackedScene 

#onready var lights: Array = []
onready var packedLights: Dictionary = {
	"candle": packedCandle,
}

func _ready() -> void:
	pass
	load_lights()

func load_lights()-> void:
	var candle = create_light_at_pos("candle", Vector2(8,5))
	candle.set_tile_size(2)

func create_light_at_pos(light_name: String, tile_pos: Vector2)-> Node2D:
	var light: Node2D = create_light(light_name)
	if light:
		light.set_tile_position(tile_pos)
	return light

func create_light(light_name: String)-> Node2D:
	var packedLightScene: PackedScene = packedLights.get(light_name, null)
	if !packedLightScene:
		return null
	var light: Node2D = packedLightScene.instance()
	_add_light(light)
	return light

func _add_light(light: Node2D)-> void:
	add_child(light)
