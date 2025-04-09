extends Node2D

@export var ore: Node2D
var has_entered = false

func enter():
	if has_entered:
		return
	has_entered = true
	$"../../AnimationPlayer".stop()
	$"../../sprites".rotation = 0
	$"../../AudioStreamPlayer".stop()
	global.add_score()
	$"../../sprites/broken".show()
	$"../../sprites/diamond".hide()
	$"../../sprites/ruby".hide()
	$"../../sprites/gold".hide()
	$"../../sprites/iron".hide()
	$"../../sprites/stone".hide()
	await get_tree().create_timer(6).timeout
	get_parent().state_number = 1
	for i in range(1):
		get_parent().get_parent().get_ore()
	has_entered = false
	$"../TakingDamage".broken = false

func exit():
	pass
