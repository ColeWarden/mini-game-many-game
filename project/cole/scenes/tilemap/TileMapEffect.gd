extends TileMap
class_name TileMapEffect

enum ID {
	AIR = -1,
	WALL = 0,
}

func is_wall_tile(tile_pos: Vector2)-> bool:
	return (get_cellv(tile_pos) == ID.WALL)
