class_name DefendState
extends State

const SPEED = 300.0
const MAX_DISTANCE = 45
var last_moved_time = 0

func enter(msg:={}):
	var anim_name = "onball-defend-front"
	var player = entity as Player
	if player.side == Game.SIDE.CPU:
		anim_name = "cpu-" + anim_name
	anim_sprite.play(anim_name)


func update(_delta: float):
	var player = entity as Player
	var game = player.game as Game
	var player_to_defend = player.get_player_to_defend() as Player
	if !player_to_defend.has_ball:
		player.linear_damp = 100
		player.linear_velocity = Vector2.ZERO
		player._state_machine.transition_to("IdleState")


func physics_update(delta):
	var curr_player = entity as Player
	var player_to_defend = curr_player.get_player_to_defend() as Player
	
	if player_to_defend != null and player_to_defend.has_ball:
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
			curr_player.linear_velocity = dir * SPEED
			anim_sprite.play("onball-defensive-slide")
			anim_sprite.flip_h = dir.x > 0
			last_moved_time = Time.get_unix_time_from_system() * 1000
		else:
			var curr_time = Time.get_unix_time_from_system() * 1000
			if curr_time - last_moved_time > 250:
				curr_player.linear_velocity = Vector2.ZERO
				var anim_name = "onball-defend-front"
				if curr_player.side == Game.SIDE.CPU:
					anim_name = "cpu-" + anim_name
				anim_sprite.play(anim_name)
	else:
		curr_player.linear_damp = 100
		curr_player.linear_velocity = Vector2.ZERO
