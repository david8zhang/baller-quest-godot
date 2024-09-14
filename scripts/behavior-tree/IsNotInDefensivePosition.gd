class_name IsNotInDefensivePosition
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var curr_player = actor as CourtPlayer
	var player_to_defend = curr_player.get_player_to_defend() as CourtPlayer
	var player_to_defend_pos = player_to_defend.global_position
	var game = curr_player.game as Game
	var hoop = game.hoop_1 if curr_player.side == Game.SIDE.CPU else game.hoop_2 as Hoop

	# Get to quarter point between player to defend and hoop
	var mid_to_hoop = Vector2((player_to_defend_pos.x + hoop.global_position.x) / 2, (player_to_defend_pos.y + hoop.global_position.y) / 2)
	var quarter_to_hoop = Vector2((player_to_defend_pos.x + mid_to_hoop.x) / 2, (player_to_defend_pos.y + mid_to_hoop.y) / 2)
	return SUCCESS if !within_bounds(curr_player.global_position, quarter_to_hoop, 45) else FAILURE


func within_bounds(position_a: Vector2, position_b: Vector2, dist_threshold: int):
	return position_a.distance_to(position_b) <= dist_threshold
