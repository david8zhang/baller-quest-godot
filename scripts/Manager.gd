class_name Manager
extends Node

@export var player_scene: PackedScene

var defensive_assigments = {}
var players: Array[Player] = []

func setup_defense():
	pass
	
func init_players(positions, side: Game.SIDE, name_prefix="Player"):
	var i = 0
	for pos in positions:
		var new_player = player_scene.instantiate() as Player
		new_player.side = side
		new_player.position = pos
		new_player.player_name = name_prefix + " " + str(i)
		players.append(new_player)
		add_child(new_player)
		i += 1

func get_player_by_name(player_name):
	for player in players:
		if player.player_name == player_name:
			return player
	return null
