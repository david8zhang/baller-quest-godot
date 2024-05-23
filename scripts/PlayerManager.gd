class_name PlayerManager
extends Node

@export var player_scene: PackedScene
var selected_player: Player = null
var players: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(5):
		var new_player = player_scene.instantiate()
		new_player.position = Vector2(i * 100 - 100, 0)
		players.append(new_player)
		add_child(new_player)
	selected_player = players[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
