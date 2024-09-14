class_name RunToDefensivePosition
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as Player
	var manager = player.get_manager()
	var offensive_positions = manager.get_defensive_positions()
	var off_pos_for_player = offensive_positions[player.player_type]
	player.move_to_position(off_pos_for_player)
	return SUCCESS