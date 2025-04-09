extends CharacterBody2D

var speed = global.player_speed
var mining = false
var can_mine : bool
var human : bool
var health = 100
var can_transform : bool
var dead : bool
var vel : int
var dir : int
var walking : bool
var transforming : bool

@onready var score_label = $score

var coordinates

func _ready():
	$RockColl.set_deferred("disabled", true)
	human = true
	can_mine = false
	can_transform = true
	dead = false
	global.player_dead = false

func _physics_process(delta):
	movement()
	animation()
	move_and_slide()
	
	score_label.text = str(global.points)
	
	if global.player_dead == true:
		get_tree().change_scene_to_file("res://scenes/death_scene.tscn")

func player():
	pass

func movement():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	if input_direction == Vector2(1,0):
		dir = 1
	elif input_direction == Vector2(-1,0):
		dir = -1
	if Input.is_action_pressed("human") and human == false:
		human = false
		speed = global.player_speed
		
	elif Input.is_action_pressed("ore") and can_transform == true:
		human = false
		speed = 0
		can_mine = false
	elif Input.is_action_pressed("break") and can_mine == true:
		mining = true
	
	if velocity != Vector2(0, 0):
		vel = 1
		walking = false
	else:
		vel = 0
		walking = true

func animation():
	if human == false:
		if Input.is_action_just_pressed("human"):
			$AnimatedSprite2D.play("untransforming")
			await get_tree().create_timer(0.6).timeout
			$HumanColl.set_deferred("disabled", false)
			$RockColl.set_deferred("disabled", true)
			$AnimatedSprite2D.play("idle")
			human = true
		elif Input.is_action_just_pressed("ore"):
			$AnimatedSprite2D.play("tranformation")
			await get_tree().create_timer(0.6).timeout
			$HumanColl.set_deferred("disabled", true)
			$RockColl.set_deferred("disabled", false)
			$AnimatedSprite2D.play("ore")
	elif human == true:
		if vel == 0 and mining == false:
			$AnimatedSprite2D.play("idle")
		elif vel == 1: 
			if Input.is_action_just_pressed("left"):
				$AnimatedSprite2D.play("walking")
				$AnimatedSprite2D.flip_h = true
			elif Input.is_action_just_pressed("right"):
				$AnimatedSprite2D.play("walking")
				$AnimatedSprite2D.flip_h = false
			elif Input.is_action_just_pressed("down"):
				if dir == 1:
					$AnimatedSprite2D.play("walking")
					$AnimatedSprite2D.flip_h = false
				elif dir == -1:
					$AnimatedSprite2D.play("walking")
					$AnimatedSprite2D.flip_h = true
			elif Input.is_action_just_pressed("up"):
				if dir == 1:
					$AnimatedSprite2D.play("walking")
					$AnimatedSprite2D.flip_h = false
				elif dir == -1:
					$AnimatedSprite2D.play("walking")
					$AnimatedSprite2D.flip_h = true
	#if mining == false:
		#pass
	#elif mining == true and can_mine == true and walking == true:
		#$AnimatedSprite2D.play("mining")
		#await get_tree().create_timer(0.45).timeout
		#mining = false
	
func mining_anim():
	if mining == true:
		$AnimatedSprite2D.play("mining")
