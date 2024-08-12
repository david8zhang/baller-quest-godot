class_name Manager
extends Node

@export var player_scene: PackedScene
var defensive_assigments = {}
var players: Array = []

func setup_defense():
	pass
	
func init_players(positions, name_prefix="Player"):
	var i = 0
	for pos in positions:
		var new_player = player_scene.instantiate()
		new_player.position = pos
		players.append(new_player)
		add_child(new_player)
		new_player.player_name = name_prefix + " " + str(i)
		i += 1
