extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	var canvasMod = $CanvasModulate
	canvasMod.visible = true
	GameManager.tileMap = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_tile(point : Vector2):
	var clicked_cell = local_to_map(point)
	var data : TileData = get_cell_tile_data(0, clicked_cell)
	if data:
		return clicked_cell
	else:
		return Vector2i.ZERO
	
func burn(tile):
	if tile != Vector2i.ZERO:
		var firstsTiles = get_surrounding_cells(tile)
		var allTiles = get_surrounding_cells(tile)
		allTiles.append(tile)
		for t in firstsTiles:
			var moreTiles = get_surrounding_cells(t)
			for ta in moreTiles:
				allTiles.append(ta)
		for t in allTiles:
			var data = get_cell_tile_data(0, t)
			if data != null:
				if get_cell_atlas_coords(0, t, false) == Vector2i(4,0):
					set_cell(0, t, 1, Vector2i(3,0), 0)
					


		

func is_tile_water(tile):
	print(get_cell_atlas_coords(0, tile, false))
	return get_cell_atlas_coords(0, tile, false) == Vector2i(5,0) or get_cell_atlas_coords(0, tile, false) == Vector2i(5,1) 
