class_name Game
extends Node2D

enum SIDE { PLAYER, CPU }

enum SHOT_TYPE { TWO_POINTER, THREE_POINTER }

enum PLAYER_TYPE {
	POINT_GUARD,
	SHOOTING_GUARD,
	SMALL_FORWARD,
	POWER_FORWARD,
	CENTER
}

@onready var court = $Court
@onready var hoop_1 = $Hoop1 as Hoop
@onready var hoop_2 = $Hoop2 as Hoop
@onready var camera = $Camera2D
@onready var scoreboard = $CanvasLayer/Scoreboard as Scoreboard
@onready var player_manager = $PlayerManager as PlayerManager
@onready var cpu_manager = $CPUManager as CPUManager

@export var ball_scene: PackedScene

var possession_side = SIDE.PLAYER
var ball

func _ready():
	hoop_1.display_front()
	hoop_2.display_back()

	if player_manager.selected_player != null:
		camera.reparent(player_manager.selected_player)

	ball = ball_scene.instantiate() as Ball
	ball.set_gravity_scale(0)
	ball.hide()
	ball.curr_poss_status = Ball.POSS_STATUS.PLAYER
	add_child(ball)

func get_ball_handler():
	for player in player_manager.players:
		if player.has_ball:
			return player
	for player in cpu_manager.players:
		if player.has_ball:
			return player
	return null
