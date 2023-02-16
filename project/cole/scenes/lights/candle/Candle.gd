extends LightArea

var i: int = 0
func update_lights()-> void:
	clear_lights()
	var size: int = tile_size
	i = (i + 1) % 2
	if (i == 1):
		size -= 1
	var inner_tiles: PoolVector2Array = get_tiles_around_cir(tile_position, size - 1)
	for tile in inner_tiles:
		var light: LightTile = create_light(tile)
		light.set_light_mode(light.LIGHT_MODE.TRANSPARENT)
	
	var outer_tiles: PoolVector2Array = get_tiles_around_cir(tile_position, size)
	outer_tiles = get_culled_pool(outer_tiles, inner_tiles)
	for tile in outer_tiles:
		var light: LightTile = create_light(tile)
		light.set_light_mode(light.LIGHT_MODE.SEMI_TRANSPARENT)

var c: int = 0
func _process(delta: float) -> void:
	c += 1
	if (c % 120 == 0):
		update_lights()
