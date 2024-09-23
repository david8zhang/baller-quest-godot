class_name PlayerManager
extends Manager

@onready var camera_controller = $"../CameraController" as CameraController
@onready var cpu_manager = $"../CPUManager"

var selected_player: PlayerCourtPlayer = null
var switch_target: PlayerCourtPlayer = null

const INBOUNDER_POSITION = Vector2(-125, 1150)
const INBOUND_RECEIVER_POSITION = Vector2(-125, 1025)

const PLAYER_CONFIGS = [
	{
		"name": 'Player 1',
		"player_type": Game.PLAYER_TYPE.POINT_GUARD,
		"default_position": Vector2(0, 250)
	},
	{
		"name": 'Player 2',
		"player_type": Game.PLAYER_TYPE.SHOOTING_GUARD,
		"default_position": Vector2(-200, 150)
	},
	{
		"name": 'Player 3',
		"player_type": Game.PLAYER_TYPE.SMALL_FORWARD,
		"default_position": Vector2(200, 15)
	},
	{
		"name": 'Player 4',
		"player_type": Game.PLAYER_TYPE.POWER_FORWARD,
		"default_position": Vector2(400, 0)
	},
	{
		"name": 'Player 5',
		"player_type": Game.PLAYER_TYPE.CENTER,
		"default_position": Vector2(-400, 0)
	}
]

const DEFAULT_OFFENSIVE_POSITIONS = {
	Game.PLAYER_TYPE.POINT_GUARD: Vector2(50, 250),
	Game.PLAYER_TYPE.SHOOTING_GUARD: Vector2(-200, 150),
	Game.PLAYER_TYPE.SMALL_FORWARD: Vector2(200, 150),
	Game.PLAYER_TYPE.POWER_FORWARD: Vector2(400, 0),
	Game.PLAYER_TYPE.CENTER: Vector2(-400, 0)
}

const DEFAULT_DEFENSIVE_POSITIONS = {
	Game.PLAYER_TYPE.POINT_GUARD: Vector2(0, 750),
	Game.PLAYER_TYPE.SHOOTING_GUARD: Vector2(-300, 900),
	Game.PLAYER_TYPE.SMALL_FORWARD: Vector2(300, 900),
	Game.PLAYER_TYPE.POWER_FORWARD: Vector2(-300, 1050),
	Game.PLAYER_TYPE.CENTER: Vector2(300, 1050)
}

var defensive_assignments = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	init_players(PLAYER_CONFIGS, Game.SIDE.PLAYER)

	# Configure player positions
	for player in players:
		var default_position = DEFAULT_OFFENSIVE_POSITIONS[player.player_type]
		player.global_position = default_position
		add_child(player)
	
	selected_player = players[0]
	selected_player.select()
	selected_player.has_ball = true

func assign_defenders():
	var cpu_players = cpu_manager.players
	for i in range(0, players.size()):
		var cpu_player = cpu_players[i] as CourtPlayer
		var player_player = players[i] as CourtPlayer
		defensive_assignments[player_player.player_name] = cpu_player.player_name


func switch_to_player(player: PlayerCourtPlayer):
	# De-select the current selected player
	selected_player.deselect()
	selected_player = player
	selected_player.select()

func hide_players():
	for p in players:
		p.hide()

func get_inbounder_position():
	return INBOUNDER_POSITION

func get_inbound_receiver_position():
	return INBOUND_RECEIVER_POSITION

func get_offensive_positions():
	return DEFAULT_OFFENSIVE_POSITIONS

func get_defensive_positions():
	return DEFAULT_DEFENSIVE_POSITIONS

func _on_main_on_game_ready():
	for player in players:
		player._on_main_on_game_ready()


func _on_cpu_manager_on_cpu_possession():
	camera_controller.set_target(selected_player)
	pass
