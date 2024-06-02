class_name PlayerManager
extends Node

@export var player_scene: PackedScene
var selected_player: Player = null
var players: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(5):
		var new_player = player_scene.instantiate()
		new_player.position = Vector2(i * 100 - 100, 150)
		players.append(new_player)
		add_child(new_player)
	selected_player = players[0]
	selected_player.select()

	
func switch_to_player(player: Player):
	# De-select the current selected player
	selected_player.deselect()
	selected_player = player
	selected_player.select()
