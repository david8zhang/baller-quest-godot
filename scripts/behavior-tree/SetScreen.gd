class_name SetScreen
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
  var curr_player = actor as CourtPlayer
  curr_player.is_screen_active = true

  # Make curr player immovable
  curr_player.linear_velocity = Vector2.ZERO
  print(curr_player.linear_velocity)
  curr_player.linear_damp = 100
  curr_player.anim_sprite.flip_h = true
  curr_player.anim_sprite.play("set-screen-side")
  curr_player.set_collision_mask_value(1, true)
  return SUCCESS