class_name Ball
extends RigidBody2D

@onready var rim_collider = $RimCollider
@onready var make_collider = $MakeDetector/CollisionShape2D

func enable_rim_collision():
	rim_collider.disabled = false
	make_collider.disabled = true
	
func disable_rim_collision():
	rim_collider.disabled = true
	make_collider.disabled = false

# logic for when ball colliders with hoop on makes
func _on_rim_detector_body_entered(body):
	if body is Hoop:
		# Slow down ball (to simulate colliding with the net)
		linear_velocity.x = linear_velocity.x * 0.5
