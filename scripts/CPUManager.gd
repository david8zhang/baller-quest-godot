class_name CPUManager
extends Manager

const CPU_POSITIONS = [
	Vector2(-400, -100),
	Vector2(-200, 0),
	Vector2(0, 100),
	Vector2(200, 0),
	Vector2(400, -100)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	init_players(CPU_POSITIONS, Game.SIDE.CPU, "CPU")
