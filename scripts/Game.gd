class_name Game
extends Node2D

enum SIDE { PLAYER, CPU }
enum SHOT_TYPE { TWO_POINTER, THREE_POINTER }

@onready var court = $Court
@onready var hoop_1 = $Hoop1 as Hoop
@onready var hoop_2 = $Hoop2 as Hoop
@onready var camera = $Camera2D
@onready var scoreboard = $CanvasLayer/Scoreboard as Scoreboard

@onready var player_manager = $PlayerManager as PlayerManager
@onready var cpu_manager = $CPUManager as CPUManager

var possession_side = SIDE.PLAYER

func _ready():
	camera.limit_left = -500
	camera.limit_right = 500
	camera.limit_top = -300
	camera.limit_bottom = 1110
	
	hoop_1.display_front()
	hoop_2.display_back()
