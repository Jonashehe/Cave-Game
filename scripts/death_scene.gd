extends Control

func _on_play_again_button_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")
	global.points = 0

func _on_quit_button_pressed():
	get_tree().quit()

func _physics_process(delta):
	$You_died/score.text = "R.I.P. \nYour score: \n" + str(global.points)
