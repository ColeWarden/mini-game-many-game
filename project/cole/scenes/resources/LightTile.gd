extends Light2D
class_name LightTile

export(Texture) var transparent_texture: Texture
export(Texture) var semi_transparent_texture: Texture
enum LIGHT_MODE {
	TRANSPARENT,
	SEMI_TRANSPARENT,
}
var light_mode: int = LIGHT_MODE.TRANSPARENT

func set_light_mode(_mode: int)-> void:
	light_mode = _mode
	if (light_mode == LIGHT_MODE.TRANSPARENT):
		set_texture(transparent_texture)
	elif (light_mode == LIGHT_MODE.TRANSPARENT):
		set_texture(semi_transparent_texture)

func _ready() -> void:
	pass # Replace with function body.

func set_world_position(pos: Vector2)-> void:
	var tile_pos: Vector2 = global_position / 32.0
	tile_pos = Vector2(floor(tile_pos.x), floor(tile_pos.y))
	set_tile_position(tile_pos)

func set_tile_position(tile_pos: Vector2)-> void:
	global_position = (tile_pos * 32.0) + Vector2(16,16)

func get_tile_position()-> Vector2:
	return (global_position - Vector2(16,16)) / 32.0
