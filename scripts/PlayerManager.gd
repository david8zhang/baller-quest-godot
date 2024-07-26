class_name PlayerManager
extends Node

@export var player_scene: PackedScene
var camera: Camera2D

var selected_player: Player = null
var players: Array = []
var is_ready = false

const PLAYER_POSITIONS = [
	Vector2(-400, 0),
	Vector2(-200, 150),
	Vector2(0, 250),
	Vector2(200, 150),
	Vector2(400, 0)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	camera = get_node("../Camera2D") as Camera2D
	for pos in PLAYER_POSITIONS:
		var new_player = player_scene.instantiate()
		new_player.position = pos
		players.append(new_player)
		add_child(new_player)
		new_player.player_name = "Player " + str(i)
		i += 1
	selected_player = players[0]
	selected_player.select()
	selected_player.has_ball = true
	selected_player._state_machine.transition_to("IdleState")
	is_ready = true
	
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.wait_time = 0.5
	timer.timeout.connect(_timer_complete)
	add_child(timer)
	

func _timer_complete():
	camera.reparent(selected_player)


func switch_to_player(player: Player):
	# De-select the current selected player
	selected_player.deselect()
	selected_player = player
	selected_player.select()
	

func hide_players():
	for p in players:
		p.hide()
