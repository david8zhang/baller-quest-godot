extends Node


@export var cpu_scene: PackedScene
var cpus = []

const CPU_POSITIONS = [
	Vector2(-400, -100),
	Vector2(-200, -50),
	Vector2(0, 50),
	Vector2(200, -50),
	Vector2(400, -100)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	for pos in CPU_POSITIONS:
		var new_cpu = cpu_scene.instantiate()
		new_cpu.position = pos
		cpus.append(new_cpu)
		add_child(new_cpu)
		i += 1
