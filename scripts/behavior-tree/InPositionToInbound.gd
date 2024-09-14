class_name InPositionToInbound
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as CourtPlayer
	var manager = player.get_manager()
	return SUCCESS if within_bounds(player.global_position, manager.get_inbounder_position(), 15) else FAILURE


func within_bounds(position_a: Vector2, position_b: Vector2, dist_threshold: int):
	return position_a.distance_to(position_b) <= dist_threshold