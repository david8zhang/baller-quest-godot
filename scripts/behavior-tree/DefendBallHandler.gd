class_name DefendBallHandler
extends ActionLeaf

const MAX_DISTANCE = 65
var last_moved_time = 0

func tick(actor: Node, _blackboard: Blackboard):
	var curr_player = actor as CourtPlayer
	var anim_sprite = curr_player.anim_sprite as AnimatedSprite2D

	var player_to_defend = curr_player.get_player_to_defend() as CourtPlayer
	curr_player.linear_damp = 0
	var player_to_defend_pos = player_to_defend.global_position
	var game = curr_player.game as Game
	var hoop = game.hoop_1 if curr_player.side == Game.SIDE.CPU else game.hoop_2 as Hoop

	# Get to quarter point between player to defend and hoop
	var mid_to_hoop = Vector2((player_to_defend_pos.x + hoop.global_position.x) / 2, (player_to_defend_pos.y + hoop.global_position.y) / 2)
	var quarter_to_hoop = Vector2((player_to_defend_pos.x + mid_to_hoop.x) / 2, (player_to_defend_pos.y + mid_to_hoop.y) / 2)

	# move toward defense point
	var dir = (quarter_to_hoop - curr_player.global_position).normalized()
	if (curr_player.global_position - quarter_to_hoop).length() > MAX_DISTANCE:
		curr_player.linear_velocity = dir * CourtPlayer.SPEED
		anim_sprite.play(Game.get_anim_for_side(curr_player, "onball-defensive-slide"))
		anim_sprite.flip_h = dir.x > 0
		last_moved_time = Time.get_unix_time_from_system() * 1000
	else:
		var curr_time = Time.get_unix_time_from_system() * 1000
		if curr_time - last_moved_time > 250:
			curr_player.linear_velocity = Vector2.ZERO
			anim_sprite.play(Game.get_anim_for_side(curr_player, "onball-defend-front"))
	return SUCCESS
