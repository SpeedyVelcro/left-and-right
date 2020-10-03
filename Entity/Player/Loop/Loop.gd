extends Node2D

var starting_angle = 0
var radius = 24
var direction = 1
var progress_rad = 0 # Progress in radians
var circle_resolution = 64 # Points in full circle

func _draw():
	# Draw arc
	print(starting_angle)
	var origin = Vector2(0, 0)
	var points = PoolVector2Array()
	for i in range(circle_resolution + 1):
		if (i as float) / ((circle_resolution as float) + 1) > progress_rad / (2 * PI):
			break
		var angle = starting_angle + (i * 2 * PI / circle_resolution) * direction
		var pos = origin + Vector2(cos(angle), sin(angle)) * radius
		points.push_back(pos)
	for i in range(points.size() - 1):
		draw_line(points[i], points[i + 1], Color.white, 2.0)

func _on_Player_loop_advance(value_rad):
	progress_rad += abs(value_rad)
	update() # Re-draw

func _on_Player_loop_cancel():
	queue_free()
