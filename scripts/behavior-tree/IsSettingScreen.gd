class_name IsSettingScreen
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var curr_player = actor as CourtPlayer
	return SUCCESS if curr_player.is_setting_screen and curr_player.screen_pos != null else FAILURE