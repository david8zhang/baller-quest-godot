class_name ShotMeter
extends Node2D

@onready var progress_bar = $ProgressBar
@onready var green_threshold_line = $GreenThreshold

var is_peaked: bool = false
var fill_box: StyleBoxFlat
var background: StyleBoxFlat
var green_threshold: float = 0

enum SHOT_RESULT { MISS, MAKE }

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
		
func get_shot_result():
	var bar_fill_pct = 100 * (progress_bar.value / progress_bar.max_value)
	var diff_between_perfect = abs(100 - bar_fill_pct)
	var perfect_threshold_pct = (1 - green_threshold) * 100
	if (diff_between_perfect <= perfect_threshold_pct):
		return SHOT_RESULT.MAKE
	else:
		if (diff_between_perfect > perfect_threshold_pct and diff_between_perfect <= 20):
			return SHOT_RESULT.MAKE if get_pct_based_value(75) else SHOT_RESULT.MISS
		elif (diff_between_perfect > 20 and diff_between_perfect <= 50):
			return SHOT_RESULT.MAKE if get_pct_based_value(50) else SHOT_RESULT.MISS
		elif (diff_between_perfect > 50):
			return SHOT_RESULT.MAKE if get_pct_based_value(25) else SHOT_RESULT.MISS
			
func get_pct_based_value(pct_chance: int):
	var random_num = randi_range(1, 100)
	return random_num <= pct_chance
		
func display_feedback():
	if progress_bar.value >= (progress_bar.max_value * self.green_threshold):
		progress_bar.value = progress_bar.max_value
		green_threshold_line.visible = false
		fill_box.bg_color = Color("#00ff00")
		
func reset():
	fill_box.bg_color = Color("#ffffff")
	green_threshold_line.visible = true
	progress_bar.value = 0
	is_peaked = false
