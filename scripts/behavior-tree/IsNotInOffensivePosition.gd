class_name NotInOffensivePosition
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as Player
	var manager = player.get_manager()
	var offensive_positions = manager.get_offensive_positions()
	var off_pos_for_player = offensive_positions[player.player_type]
	return SUCCESS if !within_bounds(off_pos_for_player, player.global_position, 15) else FAILURE


func within_bounds(position_a: Vector2, position_b: Vector2, dist_threshold: int):
	return position_a.distance_to(position_b) <= dist_threshold