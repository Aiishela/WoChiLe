extends Node2D

# Array of strokes, each stroke is an array of points
var strokes: Array = []
var current_stroke: Array = []
var is_drawing := false

@onready var guide_image = %GuideImage

func _ready():
	const HUO = preload("res://sprite/Chinese/huo.png")
	guide_image.texture = HUO
	guide_image.modulate = Color(1, 1, 1, 0.3)

	#guide_image.position = get_viewport_rect().size / 2
	
func _input(event):
	# Start stroke
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_drawing = event.pressed
		if is_drawing:
			current_stroke = []
			strokes.append(current_stroke)

	# Record stroke points
	if event is InputEventMouseMotion and is_drawing:
		current_stroke.append(event.position)
		queue_redraw()

	# Clear with C key
	if event is InputEventKey and event.pressed and event.keycode == KEY_C:
		strokes.clear()
		queue_redraw()

func _draw():
	# Draw all strokes
	for stroke in strokes:
		for i in range(1, stroke.size()):
			draw_line(stroke[i - 1], stroke[i], Color.BLACK, 6, true)
