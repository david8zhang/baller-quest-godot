class_name PlayerManager
extends Node

@export var player_scene: PackedScene
var selected_player_index: int = 0
var selected_player: Player = null
var players: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(5):
		var new_player = player_scene.instantiate()
		new_player.position = Vector2(i * 100 - 100, 150)
		players.append(new_player)
		add_child(new_player)
	selected_player = players[selected_player_index]
	selected_player.modulate = Color(0, 1, 0, 1)
	
func _input(ev: InputEvent):
	if Input.is_action_just_pressed("switch_character"):
		switch_selected_player()
	
func switch_selected_player():
	selected_player.modulate = Color(1, 1, 1, 1)
	selected_player_index = (selected_player_index + 1) % players.size()
	selected_player = players[selected_player_index]
	selected_player.modulate = Color(0, 1, 0, 1)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	pass
