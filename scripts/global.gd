extends Node2D

var points : int = 0
var type_ore : int 
#get the ore type based on number diamond1, rruby2, ggold3, iron4, stone5, broken0
var pickaxe_type : String = "normal"
 #normal, iron = +2 points, gold = +6 points, ruby = +10 points, diamond = +14 points
var player_speed : int = 100
#normal=175, up1=200, up2= 225, up3=250, up4=275, up5=300
var money_points
var money : int
var point_shower : int
var player_dead : bool

func add_money():
	money_points = points * 3
	money += money_points
	point_shower = points
	await get_tree().create_timer(2).timeout
	money_points = 0

func add_score():
	if type_ore == 1:
		points += 8
		type_ore = 0
	elif type_ore == 2:
		points += 6
		type_ore = 0
	elif type_ore == 3:
		points += 4
		type_ore = 0
	elif type_ore == 4:
		points += 2
		type_ore = 0
	elif type_ore == 5:
		points += 1
		type_ore = 0
