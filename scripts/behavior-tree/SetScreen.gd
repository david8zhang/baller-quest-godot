class_name SetScreen
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
  var curr_player = actor as CourtPlayer
  curr_player.is_screen_active = true
  var game = blackboard.get_value("Game") as Game
  
  var ball_handler = game.get_ball_handler()
  if ball_handler != null && ball_handler.get_defender() != null:
    ball_handler.get_defender().set_collision_mask_value(1, true)

  # Make curr player immovable
  curr_player.linear_velocity = Vector2.ZERO
  curr_player.anim_sprite.flip_h = true
  curr_player.anim_sprite.play("set-screen-side")
  return SUCCESS
