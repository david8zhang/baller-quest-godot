class_name Manager
extends Node

@export var player_scene: PackedScene

var defensive_assigments = {}
var players = []

func setup_defense():
	pass
	
func init_players(positions, side: Game.SIDE, name_prefix="Player"):
	var i = 0
	for pos in positions:
		var new_player = player_scene.instantiate() as Player
		new_player.side = side
		new_player.position = pos
		players.append(new_player)
		add_child(new_player)
		new_player.player_name = name_prefix + " " + str(i)
		i += 1


func get_player_by_name(name):
	for player in players:
		if player.player_name == name:
			return player
	return null
