extends CharacterBody2D

# Variables for movement
var speed = 1
var movement_direction = Vector2.ZERO
var movement_timer = 0.0
var change_interval = 2.0  # Time in seconds before changing direction
var player = null
var player_chase = false

var coordinates

func _ready():
	disappear()
	randomize()  # Initialize random seed for randomness
	change_direction()  # Set an initial direction

func _process(delta):
	movement_timer += delta
	# Change direction at set intervals
	if movement_timer >= change_interval:
		change_direction()
		movement_timer = 0.0
	
	if player_chase:
		position += (player.position - position)/ 15
		move_and_slide()
	
	if movement_direction < Vector2(0,0):
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = true
	elif movement_direction > Vector2(0,0):
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = false
	
	#enable enemy
	if global.points >= 250:
		appear()
	# Move the enemy
	move_and_collide(movement_direction * speed)

func change_direction():
	# Generate a truly random direction without bias
	movement_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

	# Optionally log the new direction for debugging
	# print("New direction: ", movement_direction)

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D and body.has_method("player"):
		if body.human == true:
			player = body
			body.speed = 0
			player_chase = true
			body.can_transform = false
			global.add_money()
			await get_tree().create_timer(0.5).timeout
			body.health = 0
			body.dead == true
			global.player_dead = true
		elif body.human == false:
			pass
		

func _on_area_2d_body_exited(body):
	if body is CharacterBody2D and body.has_method("player"):
		player_chase = false
		body.speed = global.player_speed
		randomize()
		change_direction()

func disappear():
	speed = 0
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D2.set_deferred("disabled", true)
	$PointLight2D.enabled = false
	$AnimatedSprite2D.hide()

func appear():
	speed = 1
	$CollisionShape2D.set_deferred("disabled", false)
	$PointLight2D.enabled = true
	$AnimatedSprite2D.show()
	await get_tree().create_timer(3).timeout
	$Area2D/CollisionShape2D2.set_deferred("disabled", false)
