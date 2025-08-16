extends TileMapLayer
class_name Floor

var bloom_tiles = 0

# if its not in any terrain get_cell_tile_data() returns -1
func bloom(col_shape: CollisionShape2D):
	if is_instance_of(col_shape.shape, CircleShape2D):
		var circle : CircleShape2D = col_shape.shape
		
		var affected_tiles: Array[Vector2i] = []
		for cell in get_used_cells():
			if Geometry2D.is_point_in_circle(map_to_local(cell), to_local(col_shape.global_position), float_to_local(circle.radius*col_shape.global_scale.x)):
				if get_cell_tile_data(cell).terrain != 0:
					affected_tiles.append(cell)
					bloom_tiles += 1
		
		LevelSelect.bloom += bloom_tiles
		bloom_tiles = 0
		set_cells_terrain_connect(affected_tiles, 0, 0, true)

#this only really makes sense if both global_scale.x and global_scale.y are equal but alas
func float_to_local(val: float) -> float:
	return val*1/global_scale.x
