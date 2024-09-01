class_name Manager
extends Node

#@export var player_scene: PackedScene
@export var b_tree_player_scene: PackedScene

var defensive_assigments = {}
#var players: Array[Player] = []
var b_tree_players: Array[BTreePlayer] = []

func setup_defense():
	pass
	
func init_players(positions, side: Game.SIDE, name_prefix="Player"):
	var i = 0
	for pos in positions:
#		var new_player = player_scene.instantiate() as Player
		var new_btree_player = b_tree_player_scene.instantiate() as BTreePlayer
		new_btree_player.side = side
		new_btree_player.position = pos
#		players.append(new_player)
		b_tree_players.append(new_btree_player)
		add_child(new_btree_player)
		new_btree_player.player_name = name_prefix + " " + str(i)
		i += 1


func get_player_by_name(name):
	for player in b_tree_players:
		if player.player_name == name:
			return player
	return null
