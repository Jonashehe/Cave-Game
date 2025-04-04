extends Area2D

var player_state = []

@onready var state_machine = $"../StateMachine"

func _physics_process(delta: float) -> void:
	for body in player_state:
		if body.human == true:
			state_machine.player_inside = true
		elif body.human == false:
			state_machine.player_inside = false
		elif not is_instance_valid(body):
			player_state.erase(body)

func _on_HitArea_body_entered(body):
	if  body.name == "Player":
		player_state.append(body)
		$"../StateMachine/TakingDamage".start_timer()

func _on_HitArea_body_exited(body):
	if body.name == "Player":
		player_state.erase(body)
		state_machine.player_inside = false
		$"../StateMachine/TakingDamage".stop_timer()
