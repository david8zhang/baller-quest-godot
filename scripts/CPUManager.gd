class_name CPUManager
extends Manager

@onready var player_manager = $"../PlayerManager"

const INBOUNDER_POSITION = Vector2(125, -165)
const INBOUND_RECEIVER_POSITION = Vector2(125, -25)

const CPU_POSITIONS = [
	Vector2(-400, -100),
	Vector2(-200, 0),
	Vector2(0, 100),
	Vector2(200, 0),
	Vector2(400, -100)
]

const PLAYER_CONFIGS = [
	{
		"name": 'CPU Player 1',
		"player_type": Game.PLAYER_TYPE.POINT_GUARD,
		"default_position": Vector2(0, 100)
	},
	{
		"name": 'CPU Player 2',
		"player_type": Game.PLAYER_TYPE.SHOOTING_GUARD,
		"default_position": Vector2(-200, 0)
	},
	{
		"name": 'CPU Player 3',
		"player_type": Game.PLAYER_TYPE.SMALL_FORWARD,
		"default_position": Vector2(200, 0)
	},
	{
		"name": 'CPU Player 4',
		"player_type": Game.PLAYER_TYPE.POWER_FORWARD,
		"default_position": Vector2(400, -100)
	},
	{
		"name": 'CPU Player 5',
		"player_type": Game.PLAYER_TYPE.CENTER,
		"default_position": Vector2(-400, -100)
	}
]

var defensive_assignments = {}

const DEFAULT_DEFENSIVE_POSITIONS = {
	Game.PLAYER_TYPE.POINT_GUARD: Vector2(0, 100),
	Game.PLAYER_TYPE.SHOOTING_GUARD: Vector2(-200, 0),
	Game.PLAYER_TYPE.SMALL_FORWARD: Vector2(200, 0),
	Game.PLAYER_TYPE.POWER_FORWARD: Vector2(400, -100),
	Game.PLAYER_TYPE.CENTER: Vector2(-400, -100)
}

const DEFAULT_OFFENSIVE_POSITIONS = {
	Game.PLAYER_TYPE.POINT_GUARD: Vector2(0, 650),
	Game.PLAYER_TYPE.SHOOTING_GUARD: Vector2(-300, 800),
	Game.PLAYER_TYPE.SMALL_FORWARD: Vector2(300, 800),
	Game.PLAYER_TYPE.POWER_FORWARD: Vector2(-400, 1050),
	Game.PLAYER_TYPE.CENTER: Vector2(400, 1050)
}

# Called when the node enters the scene tree for the first time.
func _ready():
	init_players(PLAYER_CONFIGS, Game.SIDE.CPU)
	assign_defenders()
	
func assign_defenders():
	var player_players = player_manager.players
	for i in range(0, players.size()):
		var cpu_player = players[i] as Player
		var player_player = player_players[i] as Player
		defensive_assignments[cpu_player.player_name] = player_player.player_name

func get_inbounder_position():
	return INBOUNDER_POSITION

func get_inbound_receiver_position():
	return INBOUND_RECEIVER_POSITION

func get_defensive_positions():
	return DEFAULT_DEFENSIVE_POSITIONS

func get_offensive_positions():
	return DEFAULT_OFFENSIVE_POSITIONS