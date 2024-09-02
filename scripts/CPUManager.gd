class_name CPUManager
extends Manager

@onready var player_manager = $"../PlayerManager"

const CPU_POSITIONS = [
	Vector2(-400, -100),
	Vector2(-200, 0),
	Vector2(0, 100),
	Vector2(200, 0),
	Vector2(400, -100)
]

var defensive_assignments = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	init_players(CPU_POSITIONS, Game.SIDE.CPU, "CPU")
	assign_defenders()
	
func assign_defenders():
	var player_players = player_manager.players
	for i in range(0, players.size()):
		var cpu_player = players[i] as Player
		var player_player = player_players[i] as Player
		defensive_assignments[cpu_player.player_name] = player_player.player_name
