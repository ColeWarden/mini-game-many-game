extends LightArea
class_name FlashLight

var look_direction: Vector2 = Vector2.DOWN


func set_look_direction(dir: Vector2)-> void:
	look_direction = dir
	update_lights()


func update_lights()-> void:
	if !lightController:
		return 
	clear_lights()
	
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
	
