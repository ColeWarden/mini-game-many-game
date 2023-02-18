extends LightSource
class_name LightArea


onready var tileMapEffect: TileMapEffect = get_tree().get_nodes_in_group("tileMapEffect").front()

var tile_blocked: bool = true
var tile_size: int = 1 setget set_tile_size


# Serves as (rect_size), (radius) and (cone_length) for inherited light classes
func set_tile_size(size: int)-> void:
	tile_size = size
	update_lights()

# Returns rectangle of tiles at (tile_pos) of size (rect_size)
func get_tiles_around_sqr(tile_pos: Vector2, rect_size: Vector2)-> PoolVector2Array:
	#var origin_position: Vector2 = (global_position / 32.0).snapped(Vector2.ONE)
	#origin_pos = tile_pos * 32.0
	var begin_tile: Vector2 = tile_pos - rect_size
	var end_tile: Vector2 = tile_pos + rect_size
	var _room_size: Vector2 = Vector2(1000, 1000)
	begin_tile.x = int(clamp(begin_tile.x, 0, _room_size.x))
	begin_tile.y = int(clamp(begin_tile.y, 0, _room_size.y))
	end_tile.x = int(clamp(end_tile.x, 0, _room_size.x))
	end_tile.y = int(clamp(end_tile.y, 0, _room_size.y))
	
	var tiles: PoolVector2Array = []
	for x in range(begin_tile.x, end_tile.x+1):
		for y in range(begin_tile.y, end_tile.y+1):
			tiles.append(Vector2(x,y))
	return tiles

#  Returns circle of tiles at (tile_pos) of radius (radius)
func get_tiles_around_cir(tile_pos: Vector2, radius: int)-> PoolVector2Array:
	var tiles_cir: PoolVector2Array = []
	var tiles_sqr: PoolVector2Array = get_tiles_around_sqr(tile_pos, Vector2(radius, radius))
	for sqr_pos in tiles_sqr:
		if tile_pos.distance_to(sqr_pos) <= radius:
			tiles_cir.append(sqr_pos)
	return tiles_cir

# Returns 90 degree cone of tiles at (tile_pos) given (cardinal direction) of length (cone_length)
func get_tiles_cone_occluded(tile_pos: Vector2, cardinal_dir: Vector2, cone_length: int)-> PoolVector2Array:
	var tiles: PoolVector2Array = []
	if !tileMapEffect.is_wall_tile(tile_pos):
		tiles.append(tile_pos)
	cone_length += 1
	var next_tile: Vector2 = tile_pos
	var max_left: int = cone_length
	var max_right: int = cone_length
	var left_dir: Vector2 = get_perpendicular_cardinal_dir(cardinal_dir)
	var right_dir: Vector2 = left_dir * -1
	
	# Start diagonalling from tile_pos towards cardinal dir
	var left_diagonal_dir: Vector2 = (left_dir + cardinal_dir)
	var right_diagonal_dir: Vector2 = (right_dir + cardinal_dir)
	var wall_forward: bool = false
	for i in range(0, cone_length):
		var center_tile_pos: Vector2 = (tile_pos + (cardinal_dir * i))
		if wall_forward:
			continue
		elif tileMapEffect.is_wall_tile(center_tile_pos):
			wall_forward = true
			tiles.append(center_tile_pos)
			continue
		tiles.append(center_tile_pos)
		for j in range(1, max_left+1):
			if (i + j) >= cone_length:
				break
			next_tile = center_tile_pos + (left_diagonal_dir * j)
			if tileMapEffect.is_wall_tile(next_tile):
				max_left = j 
				tiles.append(next_tile)
				break
			tiles.append(next_tile)
		
		for j in range(1, max_right+1):
			if (i + j) >= cone_length:
				break
			next_tile = center_tile_pos + (right_diagonal_dir * j)
			if tileMapEffect.is_wall_tile(next_tile):
				max_right = j 
				tiles.append(next_tile)
				break
			tiles.append(next_tile)
			
	return tiles


# Returns 90 degree cone of tiles at (tile_pos) given (cardinal direction) of length (cone_length)
func get_tiles_cone(tile_pos: Vector2, cardinal_dir: Vector2, cone_length: int)-> PoolVector2Array:
	var tiles: PoolVector2Array = []
	var next_tile: Vector2 = tile_pos
	var begin_tile: Vector2 = tile_pos
	var width: int = 1
	var side_vec_1: Vector2 = get_perpendicular_cardinal_dir(cardinal_dir)
	var side_vec_2: Vector2 = side_vec_1 * -1
	for i in cone_length:
		begin_tile += cardinal_dir
		tiles.append(begin_tile)
		for j in range(1, width+1):
			tiles.append(begin_tile + (side_vec_1 * j))
			tiles.append(begin_tile + (side_vec_2 * j))
		width += 1
	return tiles


# Returns 90 degree cone of tiles at (tile_pos) given (cardinal direction) of length (cone_length)
func get_tiles_line_occluded(tile_pos: Vector2, cardinal_dir: Vector2, length: int)-> PoolVector2Array:
	var tiles: PoolVector2Array = [tile_pos]
	var next_tile: Vector2 = tile_pos
	for i in length:
		next_tile += cardinal_dir
		if tileMapEffect.is_wall_tile(next_tile):
			tiles.append(next_tile)
			break
		tiles.append(next_tile)
	return tiles


func _get_wall_tiles(tiles: PoolVector2Array)-> PoolVector2Array:
	var walls: PoolVector2Array = []
	for pos in tiles:
		if tileMapEffect.is_wall_tile(pos):
			walls.append(pos)
	return walls

# Returns a random perpendicular (cardinal_dir) of another cardinal_dir.
# Getting the "other" perpendicular vector can be achived by calling (-1 * result) of this function.
func get_perpendicular_cardinal_dir(cardinal_dir: Vector2)-> Vector2:
	return Vector2(cardinal_dir.y, cardinal_dir.x)

# Removes any tiles in (cull_pool) from (source_pool) and returns the remaining tiles.
func get_culled_pool(source_pool: PoolVector2Array, cull_pool: PoolVector2Array)-> PoolVector2Array:
	var remaining_pool: PoolVector2Array = []
	var found: bool = false
	for vec2 in source_pool:
		for cull_value in cull_pool:
			if vec2 == cull_value:
				found = true
				break
		if !found:
			remaining_pool.append(vec2)
		found = false
	return remaining_pool
