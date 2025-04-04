extends TileMap

var ore = preload("res://oree/oree.tscn")
var player = preload("res://scenes/player.tscn")
var enemyone = preload("res://scenes/enemyone.tscn")
var enemytwo = preload("res://scenes/enemytwo.tscn")
var enemythree = preload("res://scenes/enemythree.tscn")

var enemyspawn = ["spawn", "no"]
var spawn : bool

var player_num = 0
var enemyone_num = 0
var enemytwo_num = 0
var enemythree_num = 0

func _ready():
	spawn_scenes()

func spawn_scenes():
	await get_tree().process_frame
	for i in range(get_used_rect().position.x, get_used_rect().end.x):
		for j in range(get_used_rect().position.y, get_used_rect().end.y):
			var coordinates = Vector2i(i, j)
			var tile_data = get_cell_tile_data(0, coordinates)
			if tile_data == null:
				continue
			elif tile_data.get_custom_data("ore_floor"):
				var instance = ore.instantiate()
				instance.coordinates = coordinates
				instance.position = map_to_local(coordinates)
				add_child(instance)
			elif tile_data.get_custom_data("enemyone_spawn"):
				if enemyone_num < 5:
					var instance = enemyone.instantiate()
					instance.coordinates = coordinates
					instance.position = map_to_local(coordinates)
					add_child(instance)
			elif tile_data.get_custom_data("enemytwo_spawn"):
				if enemytwo_num < 6:
					var instance = enemytwo.instantiate()
					instance.coordinates = coordinates
					instance.position = map_to_local(coordinates)
					add_child(instance)
					enemytwo_num += 1
			elif tile_data.get_custom_data("enemythree_spawn"):
				if enemythree_num < 6:
					var instance = enemythree.instantiate()
					instance.coordinates = coordinates
					instance.position = map_to_local(coordinates)
					add_child(instance)
					enemythree_num += 1
			elif tile_data.get_custom_data("player_spawn"):
				if player_num < 1:
					var instance = player.instantiate()
					instance.coordinates = coordinates
					instance.position = map_to_local(coordinates)
					add_child(instance)
					player_num +=1 
				if player_num >= 1:
					continue

	
