class_name Ball
extends RigidBody2D

@onready var collider = $Collider
@onready var floor_collider = $FloorCollider
@onready var make_collider: CollisionShape2D = $MakeDetector/CollisionShape2D
@onready var player_collider: CollisionShape2D = $PlayerDetector/CollisionShape2D
@onready var player_detector: Area2D = $PlayerDetector

var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	player_collider.disabled = true


func enable_collision():
	collider.set_deferred("disabled", false)
	make_collider.set_deferred("disabled", true)

	
func disable_collision():
	collider.set_deferred("disabled", true)
	make_collider.set_deferred("disabled", false)


func _on_player_detector_body_entered(body):
	var player = body as Player
	player.receive_pass(self)

# logic for when ball colliders with hoop on makes
func _on_make_detector_body_entered(body: Node2D):
	if body.name == "NetCollider":
		# Slow down ball (to simulate colliding with the net)
		linear_velocity.x = linear_velocity.x * 0.25
		linear_velocity.y = linear_velocity.y * 0.75
		enable_collision()
