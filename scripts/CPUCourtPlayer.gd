class_name CPUCourtPlayer
extends CourtPlayer

func get_player_to_defend():
	if cpu_manager.defensive_assignments.has(player_name):
		var player_to_defend_name = cpu_manager.defensive_assignments[player_name]
		return player_manager.get_player_by_name(player_to_defend_name)
	return null

func handle_ball_collision(ball: Ball):
	super.handle_ball_collision(ball)
	cpu_manager.on_cpu_possession.emit()