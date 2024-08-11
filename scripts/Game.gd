class_name Game
extends Node2D

@onready var court = $Court
@onready var player_manager = $PlayerManager as PlayerManager
@onready var hoop_1 = $Hoop1 as Hoop
@onready var hoop_2 = $Hoop2 as Hoop

@onready var camera = $Camera2D
var is_flipped = false
var is_rotating = false
var cached_positions = {}

func _ready():
	camera.limit_left = -500
	camera.limit_right = 500
	camera.limit_top = -300
	camera.limit_bottom = 1110
	
	hoop_1.display_front()
	hoop_2.display_back()
