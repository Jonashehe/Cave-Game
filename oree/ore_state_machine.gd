extends Node2D

var current_state = null
var player_inside = false  # Tracks if the player is in the hit area
var state_number : int

func _ready():
	current_state= $Untouched  # Start in Untouched state
	state_number = 1

func _physics_process(delta: float) -> void:
	if state_number == 1:
		current_state = $Untouched
		$Untouched.enter()
	elif state_number == 2:
		current_state = $TakingDamage
		$TakingDamage.enter()
	elif state_number == 3:
		current_state = $Broken
		$Broken.enter()

func take_damage():
	if player_inside and current_state.name != "Broken":
		current_state = $TakingDamage
		$TakingDamage.enter()
