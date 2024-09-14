class_name CPUCourtPlayer
extends CourtPlayer

func get_player_to_defend():
	if cpu_manager.defensive_assignments.has(player_name):
		var player_to_defend_name = cpu_manager.defensive_assignments[player_name]
		return player_manager.get_player_by_name(player_to_defend_name)
	return null
		