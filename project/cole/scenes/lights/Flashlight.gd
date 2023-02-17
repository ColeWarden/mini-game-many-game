extends LightArea
class_name FlashLight

var look_direction: Vector2 = Vector2.DOWN

enum MODE {
	CONE,
	BEAM,
	AREA,
	limit,
}

var mode: int = MODE.CONE

func set_mode(_mode: int)-> void:
	mode = _mode
	update_lights()

func get_mode()-> int:
	return mode

func set_look_direction(dir: Vector2)-> void:
	look_direction = dir
	update_lights()


func update_lights()-> void:
	if !lightController:
		return 
	clear_lights()
	if (mode == MODE.CONE):
		set_mode_cone()
	elif (mode == MODE.BEAM):
		set_mode_beam()
	elif (mode == MODE.AREA):
		set_mode_area()

func set_mode_cone()-> void:
	var surrounding_tiles: PoolVector2Array = get_tiles_cone_occluded(tile_position, look_direction, tile_size)
	var lightTile: LightTile
	for t_pos in surrounding_tiles:
		lightTile = create_light(t_pos)
		lightTile.set_light_mode(lightTile.LIGHT_MODE.TRANSPARENT)
	
	var edge_tiles: PoolVector2Array = get_tiles_cone(tile_position - look_direction, look_direction, tile_size + 1)
	edge_tiles = get_culled_pool(edge_tiles, surrounding_tiles)
	for t_pos in edge_tiles:
		lightTile = create_light(t_pos)
		lightTile.set_light_mode(lightTile.LIGHT_MODE.SEMI_TRANSPARENT)
	
	var perpendicular_vec: Vector2 = get_perpendicular_cardinal_dir(look_direction)
	var size: Vector2 = Vector2(abs(perpendicular_vec.x), abs(perpendicular_vec.y))
	surrounding_tiles = get_tiles_around_sqr(tile_position - look_direction, size)
	for t_pos in surrounding_tiles:
		lightTile = create_light(t_pos)
		lightTile.set_light_mode(lightTile.LIGHT_MODE.SEMI_TRANSPARENT)

func set_mode_beam()-> void:
	var beam_length: int = tile_size
	if beam_length % 2 == 0:
		beam_length += 1
	var center_tile: Vector2 = (tile_position + (look_direction * int(ceil(beam_length/2.0))))
	var beam_width: int = 1
	var perpen: Vector2 = get_perpendicular_cardinal_dir(look_direction)
	perpen = Vector2(abs(perpen.x), abs(perpen.y))
	perpen *= beam_length
	var rect_size: Vector2 = (look_direction * beam_length) + (perpen * beam_width)
	var surrounding_tiles: PoolVector2Array = get_tiles_around_sqr(center_tile, rect_size)
	var lightTile: LightTile
	for t_pos in surrounding_tiles:
		lightTile = create_light(t_pos)
		lightTile.set_light_mode(lightTile.LIGHT_MODE.TRANSPARENT)
	

func set_mode_area()-> void:
	var cir_size: int = tile_size
	var outer_tiles: PoolVector2Array = get_tiles_around_cir(tile_position, cir_size)
	var inner_tiles: PoolVector2Array = get_tiles_around_cir(tile_position, cir_size-1)
	var semi_tiles: PoolVector2Array = get_culled_pool(outer_tiles, inner_tiles)
	
	var lightTile: LightTile
	for t_pos in semi_tiles:
		lightTile = create_light(t_pos)
		lightTile.set_light_mode(lightTile.LIGHT_MODE.SEMI_TRANSPARENT)
	for t_pos in inner_tiles:
		lightTile = create_light(t_pos)
		lightTile.set_light_mode(lightTile.LIGHT_MODE.TRANSPARENT)

