extends LightArea

onready var flicker_rate: int = _get_rand_flicker()
export(Color) var transparent_color: Color = Color(0.84375, 0.560303, 0.560303)
export(Color) var semi_transparent_color: Color = Color()
var candle_state: int = 0

func update_lights()-> void:
	clear_lights()
	var size: int = tile_size
	
	var outer_tiles: PoolVector2Array = get_tiles_around_cir(tile_position, tile_size)
	var outer_mode: int = LightTile.LIGHT_MODE.TRANSPARENT
	var outer_color: Color = transparent_color
	
	if (candle_state == 1):
		var inner_tiles: PoolVector2Array = get_tiles_around_cir(tile_position, tile_size-1)
		var inner_mode: int = LightTile.LIGHT_MODE.TRANSPARENT
		var inner_color: Color = transparent_color
		
		size -= 1
		outer_tiles = get_culled_pool(outer_tiles, inner_tiles)
		outer_mode = LightTile.LIGHT_MODE.SEMI_TRANSPARENT
		outer_color = semi_transparent_color
		
		for tile in inner_tiles:
			var light: LightTile = create_light(tile)
			light.set_light_mode(inner_mode)
			light.set_light_color(inner_color)
	
	for tile in outer_tiles:
		var light: LightTile = create_light(tile)
		light.set_light_color(outer_color)
		light.set_light_mode(outer_mode)

var c: int = 0
func _process(_delta: float) -> void:
	c += 1
	if (c % flicker_rate == 0):
		c = 0
		flicker_rate = _get_rand_flicker()
		candle_state = (candle_state + 1) % 2
		update_lights()

func _get_rand_flicker()-> int:
	return (randi() % 50) + 50
