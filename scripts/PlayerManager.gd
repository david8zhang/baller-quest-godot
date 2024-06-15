class_name PlayerManager
extends Node

@export var player_scene: PackedScene
var selected_player: Player = null
var players: Array = []

const PLAYER_POSITIONS = [
	Vector2(-400, 0),
	Vector2(-200, 100),
	Vector2(0, 200),
	Vector2(200, 100),
	Vector2(400, 0)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	for pos in PLAYER_POSITIONS:
		var new_player = player_scene.instantiate()
		new_player.global_position = pos
		players.append(new_player)
		add_child(new_player)
		new_player.player_name = "Player " + str(i)
		i += 1
	selected_player = players[0]
	selected_player.select()
	selected_player.has_ball = true


func switch_to_player(player: Player):
	# De-select the current selected player
	selected_player.deselect()
	selected_player = player
	selected_player.select()
