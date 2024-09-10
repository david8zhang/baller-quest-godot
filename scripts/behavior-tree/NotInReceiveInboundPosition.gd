class_name NotInReceiveInboundPosition
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as Player
	var manager = player.get_manager()
	return SUCCESS if !within_bounds(player.global_position, manager.get_inbound_receiver_position(), 5) else FAILURE


func within_bounds(position_a: Vector2, position_b: Vector2, dist_threshold: int):
	return position_a.distance_to(position_b) <= dist_threshold