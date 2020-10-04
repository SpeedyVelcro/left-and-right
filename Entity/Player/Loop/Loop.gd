# Loop.gd

extends Node2D

var starting_angle = 0
var radius = 24
var direction = 1
var progress_rad = 0 # Progress in radians
var circle_resolution = 64 # Points in full circle
var capturables = []

signal complete

func _draw():
	# Draw arc
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

func complete():
	for cap in capturables:
		connect("complete", cap, "_on_Loop_complete", [], CONNECT_ONESHOT)
	emit_signal("complete")

func _on_Player_loop_advance(value_rad):
	progress_rad += abs(value_rad)
	update() # Re-draw
	if progress_rad >= 2 * PI:
		complete()

func _on_Player_loop_cancel():
	queue_free()

# Getters and setters
func get_radius():
	return radius

func set_radius(value):
	radius = value
	$Area2D/CollisionShape2D.shape.set_radius(value)


func _on_Area2D_area_entered(area):
	# area is known to be a Capturable by collision mask
	capturables.append(area)

func _on_Area2D_area_exited(area):
	# area is known to be a Capturable by collision mask
	# This will probably never happen anyway but oh well
	capturables.erase(area)
