class_name Ball
extends RigidBody2D

var screen_size
var shot_status
@onready var game = get_node("/root/Main") as Game
@onready var collider = $CollisionShape2D
@onready var net_detector = $NetDetector/CollisionShape2D
@onready var player_detector = $PlayerDetector/CollisionShape2D
@onready var sprite = $Sprite2D

func _ready():
	screen_size = get_viewport_rect().size
	sprite.scale = Vector2(3.5, 3.5)


func enable_rim_collider():
	set_collision_mask_value(2, true)


func disable_rim_collider():
	set_collision_mask_value(2, false)


func enable_ground_collider():
	set_collision_mask_value(4, true)
	

func disable_ground_collider():
	set_collision_mask_value(4, false)
	

func disable_player_detector():
	player_detector.set_deferred("disabled", true)


func enable_player_detector():
	player_detector.set_deferred("disabled", false)


func _physics_process(delta):
	if self.linear_velocity.y < 0:
		disable_ground_collider()
		disable_rim_collider()
	elif self.linear_velocity.y > 0:
		enable_ground_collider()
		if shot_status == ShotMeter.SHOT_RESULT.MISS:
			enable_rim_collider()


func _on_net_detector_area_entered(area):
	linear_velocity.x = linear_velocity.x * 0.25
	linear_velocity.y = linear_velocity.y * 0.75


func _on_player_detector_body_entered(body):
	var player = body as Player
	player.handle_ball_collision(self)
