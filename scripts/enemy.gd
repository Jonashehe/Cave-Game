extends CharacterBody2D
# Variables for movement
var speed = 0
var movement_direction = Vector2.ZERO
var movement_timer = 0.0
var change_interval = 2.0  # Time in seconds before changing direction
var player = null
var player_chase = false

var coordinates

func _ready():
	randomize()  # Initialize random seed for randomness
	change_direction()  # Set an initial direction

func _process(delta):
	raycast_check()
	movement_timer += delta
	# Change direction at set intervals
	if movement_timer >= change_interval:
		change_direction()
		movement_timer = 0.0
	
	if player_chase:
		position += (player.position - position)/ 15
		move_and_slide()
	
	# Move the enemy
	move_and_collide(movement_direction * speed)

func change_direction():
	# Generate a truly random direction without bias
	movement_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

	# Optionally log the new direction for debugging
	# print("New direction: ", movement_direction)
	
func raycast_check():
	if $south.is_colliding():
		var collider = $south.get_collider()
		if collider and collider.has_method("player"):
			print(1)
	elif $south_west.is_colliding():
		var collider = $south_west.get_collider()
		if collider and collider.has_method("player"):
			print(2)
	elif $south_east.is_colliding():
		var collider = $south_east.get_collider()
		if collider and collider.has_method("player"):
			print(3)
	elif $north.is_colliding():
		var collider = $north.get_collider()
		if collider and collider.has_method("player"):
			print(4)
	elif $north_west.is_colliding():
		var collider = $north_west.get_collider()
		if collider and collider.has_method("player"):
			print(5)
	elif $north_east.is_colliding():
		var collider = $north_east.get_collider()
		if collider and collider.has_method("player"):
			print(6)
	elif $west.is_colliding():
		var collider = $west.get_collider()
		if collider and collider.has_method("player"):
			print(7)
	elif $east.is_colliding():
		var collider = $east.get_collider()
		if collider and collider.has_method("player"):
			print(8)
	
	


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D and body.has_method("player"):
		player = body
		body.speed = 0
		player_chase = true
		await get_tree().create_timer(0.5).timeout
		body.health = 0


func _on_area_2d_body_exited(body):
	if body is CharacterBody2D and body.has_method("player"):
		player_chase = false
		body.speed = 400
		randomize()
		change_direction()
