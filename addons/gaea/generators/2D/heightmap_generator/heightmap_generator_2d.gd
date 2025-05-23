@tool
@icon("heightmap_generator_2d.svg")
class_name HeightmapGenerator2D
extends ChunkAwareGenerator2D
## Generates terrain using a heightmap from a noise texture.
## @tutorial(Generators): https://benjatk.github.io/Gaea/#/generators/
## @tutorial(HeightmapGenerator): https://benjatk.github.io/Gaea/#/generators/heightmap

@export var settings: HeightmapGenerator2DSettings


func _ready() -> void:
	if settings.random_noise_seed:
		settings.noise.seed = randi()

	super()


func generate(starting_grid: GaeaGrid = null) -> void:
	if Engine.is_editor_hint() and not editor_preview:
		return
	var time_now :int = Time.get_ticks_msec()

	if not settings:
		push_error("%s doesn't have a settings resource" % name)
		return

	if settings.random_noise_seed:
		settings.noise.seed = randi()

	if starting_grid == null:
		erase()
	else:
		grid = starting_grid
	_set_grid()
	_apply_modifiers(settings.modifiers)

	if is_instance_valid(next_pass):
		next_pass.generate(grid)
		return

	var time_elapsed :int = Time.get_ticks_msec() - time_now
	if OS.is_debug_build():
		print("%s: Generating took %s seconds" % [name, float(time_elapsed) / 100 ])

	grid_updated.emit()


func generate_chunk(chunk_position: Vector2i, starting_grid: GaeaGrid = null) -> void:
	if Engine.is_editor_hint() and not editor_preview:
		return

	if not settings:
		push_error("%s doesn't have a settings resource" % name)
		return

	if starting_grid == null:
		erase_chunk(chunk_position)
	else:
		grid = starting_grid

	_set_chunk_grid(chunk_position)
	_apply_modifiers_chunk(settings.modifiers, chunk_position)

	generated_chunks.append(chunk_position)

	if is_instance_valid(next_pass):
		if not next_pass is ChunkAwareGenerator2D:
			push_error("next_pass generator is not a ChunkAwareGenerator2D")
		else:
			next_pass.generate_chunk(chunk_position, grid)
			return

	chunk_updated.emit(chunk_position)


func _set_grid() -> void:
	var max_height: int = 0
	for x in range(settings.world_length):
		max_height = maxi(
			floor(settings.noise.get_noise_1d(x) * settings.height_intensity + settings.height_offset),
			max_height
		)

	var area := Rect2i(
		# starting point
		Vector2i(0, -max_height),
		# size
		Vector2i(settings.world_length, max_height - settings.min_height)
	)

	_set_grid_area(area)


func _set_chunk_grid(chunk_position: Vector2i) -> void:
	_set_grid_area(Rect2i(chunk_position * chunk_size, Vector2i(chunk_size, chunk_size)))


func _set_grid_area(area: Rect2i) -> void:
	for x in range(area.position.x, area.end.x):
		if not settings.infinite:
			if x < 0 or x > settings.world_length:
				continue

		var height = floor(settings.noise.get_noise_1d(x) * settings.height_intensity + settings.height_offset)
		for y in range(area.position.y, area.end.y):
			if y > -height and y <= -settings.min_height:
				grid.set_valuexy(x, y, settings.tile)
