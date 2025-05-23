extends Node2D

@export var ore: Node2D
var health = 3  # Ore starts with 3 HP
var broken : bool
var timer_running : bool = false
var breaking : bool = false

func _physics_process(delta: float) -> void:
	pass

func enter():
	if ore == null:
		print("Error: Ore is not assigned in TakingDamage.gd!")
		return  # Prevent crashing if ore is missing

	var state_machine = ore.get_node("StateMachine")  # Get the actual StateMachine node

func start_timer():
	breaking = true
	$"../../AnimationPlayer".play("Breakign")
	$"../../AudioStreamPlayer".play()
	if timer_running:
		return
	timer_running = true
	await get_tree().create_timer(3.0).timeout  # Wait for 3 seconds
	
	if get_parent().player_inside:
		get_parent().state_number = 3
	breaking = false
	broken = true
	timer_running = false

func stop_timer():
	timer_running = false
	breaking = false
	$"../../AnimationPlayer".stop()
	$"../../sprites".rotation = 0
	$"../../AudioStreamPlayer".stop()

func exit():
	pass
