class_name ShotMeter
extends Node2D

@onready var progress_bar = $ProgressBar
@onready var green_threshold_line = $GreenThreshold

var is_peaked: bool = false
var fill_box: StyleBoxFlat
var background: StyleBoxFlat
var green_threshold: float = 0


func _ready():
	fill_box = StyleBoxFlat.new()
	background = StyleBoxFlat.new()
	background.bg_color = Color("#444444")
	progress_bar.add_theme_stylebox_override("fill", fill_box)
	progress_bar.add_theme_stylebox_override("background", background)
	fill_box.bg_color = Color("#ffffff")

func fill(amount: int, green_threshold: float):
	self.green_threshold = green_threshold
	var line_pos = (1 - green_threshold) * progress_bar.size.y
	green_threshold_line.position.y = progress_bar.position.y + line_pos
	if is_peaked:
		progress_bar.value -= amount
	else:
		progress_bar.value += amount
	if (progress_bar.value == progress_bar.max_value):
		is_peaked = true

func display_feedback():
	if progress_bar.value >= (progress_bar.max_value * self.green_threshold):
		progress_bar.value = progress_bar.max_value
		green_threshold_line.visible = false
		fill_box.bg_color = Color("#00ff00")
