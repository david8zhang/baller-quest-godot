class_name PlayerControl
extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard):
	var player = actor as BTreePlayer
	player.anim_sprite.play("dribble-idle")
