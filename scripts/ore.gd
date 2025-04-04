extends Node2D

var ores = ["stone", "iron", "gold", "ruby", "diamond"]
var health : int
var can_be_hit : bool
var can_lose_health : bool
var bodies = []
var player_in_area: bool
var coordinates

func _ready():
	can_lose_health = false
	can_be_hit = false
	#picks 1 ore randomly to start the game
	for i in range(1):
		get_ore()

func _physics_process(delta):
	get_mined()
	if Input.is_action_pressed("break") and can_be_hit == true and player_in_area == true:
		can_lose_health = true
		get_hit()
		
	for body in bodies:
		if body.human == true:
			body.can_mine = true
			can_be_hit = true
		elif body.human == false:
			body.can_mine = false
			can_be_hit = false

func random_ore_picker():
	#picks 1 ore randomly
	for i in range(1):
		get_ore()

func get_ore():
	#selects the picked ore as its value
	var random_ore = ores[randi() % ores.size()]
	#checks the value or random_ore and does its thing depending on the ore
	if random_ore == "diamond":
		global.type_ore = 1
		health = 125
		#sprite selection
		$sprites/broken.hide()
		$sprites/stone.hide()
		$sprites/iron.hide()
		$sprites/gold.hide()
		$sprites/ruby.hide()
		$sprites/diamond.show()
		#light selection
		$lights/diamond.show()
		$lights/ruby.hide()
		$lights/gold.hide()
		$lights/remainingtwo.hide()
	elif random_ore == "ruby":
		global.type_ore = 2
		health = 100
		#sprite selection
		$sprites/broken.hide()
		$sprites/stone.hide()
		$sprites/iron.hide()
		$sprites/gold.hide()
		$sprites/ruby.show()
		$sprites/diamond.hide()
		#light selection
		$lights/diamond.hide()
		$lights/ruby.show()
		$lights/gold.hide()
		$lights/remainingtwo.hide()
	elif random_ore == "gold":
		global.type_ore = 3
		health = 75
		#sprite selection
		$sprites/broken.hide()
		$sprites/stone.hide()
		$sprites/iron.hide()
		$sprites/gold.show()
		$sprites/ruby.hide()
		$sprites/diamond.hide()
		#light selection
		$lights/diamond.hide()
		$lights/ruby.hide()
		$lights/gold.show()
		$lights/remainingtwo.hide()
	elif random_ore == "iron":
		global.type_ore = 4
		health = 50
		#sprite selection
		$sprites/broken.hide()
		$sprites/stone.hide()
		$sprites/iron.show()
		$sprites/gold.hide()
		$sprites/ruby.hide()
		$sprites/diamond.hide()
		#light selection
		$lights/diamond.hide()
		$lights/ruby.hide()
		$lights/gold.hide()
		$lights/remainingtwo.show()
	elif random_ore == "stone":
		global.type_ore = 5
		health = 25
		#sprite selection
		$sprites/broken.hide()
		$sprites/stone.show()
		$sprites/iron.hide()
		$sprites/gold.hide()
		$sprites/ruby.hide()
		$sprites/diamond.hide()
		#light selection
		$lights/diamond.hide()
		$lights/ruby.hide()
		$lights/gold.hide()
		$lights/remainingtwo.show()

func get_mined():
	if health <= 0:
		$mine_sound.play()
		global.add_score()
		health = 999999
		#sprite selection
		$sprites/broken.show()
		$sprites/stone.hide()
		$sprites/iron.hide()
		$sprites/gold.hide()
		$sprites/ruby.hide()
		$sprites/diamond.hide()
		#light selection
		$lights/diamond.hide()
		$lights/ruby.hide()
		$lights/gold.hide()
		$lights/remainingtwo.hide()
		await get_tree().create_timer(2).timeout
		random_ore_picker()

func get_hit():
	if can_lose_health == true:
		health - 25
		$mine_sound.play()
		can_lose_health = false
		can_be_hit_state()

func can_be_hit_state():
	can_lose_health = false
	await get_tree().create_timer(0.5).timeout
	can_lose_health = true
	

func _on_in_area_body_entered(body):
	if body is CharacterBody2D and body.has_method("player") and body.human == true:
		bodies.append(body)
		body.can_mine = true
		player_in_area = true
	elif body is CharacterBody2D and body.has_method("player") and body.human == false:
		bodies.append(body)
		body.can_mine = false
		player_in_area = false


func _on_in_area_body_exited(body):
	if body is CharacterBody2D and body.has_method("player"):
		bodies.erase(body)
		body.can_mine = false
		player_in_area = false
	elif body is CharacterBody2D and !body.has_method("player"):
		pass
	elif body is Node2D:
		pass


func _on_mine_true_area_entered(area):
	if area is Area2D and area.name == "mouse_area":
		can_be_hit = true


func _on_mine_true_area_exited(area):
	if area is Area2D and area.name == "mouse_area":
		can_be_hit = false
