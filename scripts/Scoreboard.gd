class_name Scoreboard
extends Control

@onready var player_score = $PlayerScore as Label
@onready var cpu_score = $CPUScore as Label

var player_score_value = 0
var cpu_score_value = 0

func add_score(side: Game.SIDE, points: int):
	if side == Game.SIDE.PLAYER:
		player_score_value += points
		player_score.text = "Player: " + str(player_score_value)
	elif side == Game.SIDE.CPU:
		cpu_score_value += points
		cpu_score.text = "CPU: " + str(cpu_score_value)
