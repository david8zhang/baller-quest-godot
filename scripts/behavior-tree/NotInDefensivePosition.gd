class_name NotInDefensivePosition
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as CourtPlayer
	var manager = player.get_manager()
	var defensive_positions = manager.get_defensive_positions()
	var def_pos_for_player = defensive_positions[player.player_type]
	return SUCCESS if !within_bounds(def_pos_for_player, player.global_position, 15) else FAILURE


func within_bounds(position_a: Vector2, position_b: Vector2, dist_threshold: int):
	return position_a.distance_to(position_b) <= dist_threshold