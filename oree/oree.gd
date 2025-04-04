extends Node2D

var ores = ["stone", "iron", "gold", "ruby", "diamond"]
@onready var state_machine = $StateMachine
var coordinates

func _ready() -> void:
	$StateMachine/TakingDamage.broken == false
	for i in range(1):
		get_ore()

func _physics_process(delta: float) -> void:
	if state_machine.player_inside:
		state_machine.take_damage()

func random_ore_picker():
	#picks 1 ore randomly
	for i in range(1):
		get_ore()

func get_ore():
	print(1)
	#selects the picked ore as its value
	var random_ore = ores[randi() % ores.size()]
	if random_ore == "diamond":
		global.type_ore = 1
		$sprites/broken.hide()
		$sprites/stone.hide()
		$sprites/iron.hide()
		$sprites/gold.hide()
		$sprites/ruby.hide()
		$sprites/diamond.show()
	elif random_ore == "ruby":
		global.type_ore = 2
		$sprites/broken.hide()
		$sprites/stone.hide()
		$sprites/iron.hide()
		$sprites/gold.hide()
		$sprites/ruby.show()
		$sprites/diamond.hide()
	elif random_ore == "gold":
		global.type_ore = 3
		$sprites/broken.hide()
		$sprites/stone.hide()
		$sprites/iron.hide()
		$sprites/gold.show()
		$sprites/ruby.hide()
		$sprites/diamond.hide()
	elif random_ore == "iron":
		global.type_ore = 4
		$sprites/broken.hide()
		$sprites/stone.hide()
		$sprites/iron.show()
		$sprites/gold.hide()
		$sprites/ruby.hide()
		$sprites/diamond.hide()
	elif random_ore == "stone":
		global.type_ore = 5
		$sprites/broken.hide()
		$sprites/stone.show()
		$sprites/iron.hide()
		$sprites/gold.hide()
		$sprites/ruby.hide()
		$sprites/diamond.hide()
