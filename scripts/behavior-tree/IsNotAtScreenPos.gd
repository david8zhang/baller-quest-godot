class_name IsNotAtScreenPos
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var curr_player = actor as CourtPlayer
	return SUCCESS if !within_bounds(curr_player.global_position, curr_player.screen_pos, 15) else FAILURE

func within_bounds(position_a: Vector2, position_b: Vector2, dist_threshold: int):
	return position_a.distance_to(position_b) <= dist_threshold