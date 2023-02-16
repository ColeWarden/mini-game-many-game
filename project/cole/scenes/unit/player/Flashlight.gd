extends LightSource
class_name FlashLight

var radius: int = 3
var look_direction: Vector2 = Vector2.DOWN


func set_look_direction(dir: Vector2)-> void:
	look_direction = dir
	update_light()


func update_light()-> void:
	if !lightController:
		return 
	clear_lights()
	
	var surrounding_tiles: PoolVector2Array = get_tiles_cone(tile_position, look_direction, radius)
	#get_tiles_around(tile_pos, Vector2(radius, radius))
	var lightTile: LightTile
	for t_pos in surrounding_tiles:
		lightTile = lightController.create_light(t_pos)
		lightTile.set_light_mode(lightTile.LIGHT_MODE.TRANSPARENT)
		add_light(lightTile)
	
	var edge_tiles: PoolVector2Array = get_tiles_cone(tile_position - look_direction, look_direction, radius + 1)
	edge_tiles = get_culled_pool(edge_tiles, surrounding_tiles)
	for t_pos in edge_tiles:
		lightTile = lightController.create_light(t_pos)
		lightTile.set_light_mode(lightTile.LIGHT_MODE.SEMI_TRANSPARENT)
		add_light(lightTile)

