class_name BTreePlayer
extends RigidBody2D

var screen_size
var side
var player_name

@onready var highlight = $Highlight as Sprite2D
@onready var anim_sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var feet_area = $FeetArea as Area2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var player_manager: PlayerManager = get_node("/root/Main/PlayerManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	highlight.visible = false
	anim_sprite.scale = Vector2(3, 3)
	highlight.scale = Vector2(
		2 * highlight.scale.x,
		2 * highlight.scale.y
	)
	highlight.position = Vector2(
		anim_sprite.position.x,
		anim_sprite.position.y + 40,
	)
	feet_area.scale = Vector2(3, 3)
	collision_shape_2d.scale = Vector2(3, 3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func select():
	player_manager.camera.reparent(self)
	highlight.visible = true


func deselect():
	highlight.visible = false


func is_selected():
	return player_manager.selected_player == self
