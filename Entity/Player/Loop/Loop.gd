# Loop.gd

extends Node2D

var starting_angle = 0
var radius = 24
var direction = 1
var progress_rad = 0 # Progress in radians
var circle_resolution = 64 # Points in full circle
var capturables = []
var alpha = 1.0
var success_lifetime_sec = 0.5
# Success circle
var draw_success_circle = false
var success_circle_progress = 0.0
var success_circle_time = 1.0

signal complete

func _process(delta):
	if draw_success_circle:
		success_circle_progress += delta / success_circle_time
		update()
		if success_circle_progress >= 1.0:
			draw_success_circle = false

func _draw():
	# Draw arc
	# TODO: fuck I just realised there's an inbuilt function for this, should probably replace everything
	var origin = Vector2(0, 0)
	var points = PoolVector2Array()
	var color = Color.white
	color.a = alpha
	for i in range(circle_resolution + 1):
		if (i as float) / ((circle_resolution as float) + 1) > progress_rad / (2 * PI):
			break
		var angle = starting_angle + (i * 2 * PI / circle_resolution) * direction
		var pos = origin + Vector2(cos(angle), sin(angle)) * radius
		points.push_back(pos)
	for i in range(points.size() - 1):
		draw_line(points[i], points[i + 1], color, 2.0)
	# Draw success circle
	if draw_success_circle:
		var initial_a = 0.5
		var final_a = 0.0
		var initial_scale = 1.0
		var final_scale = 1.3
		var a = initial_a + (final_a - initial_a) * success_circle_progress
		var s = initial_scale + (final_scale - initial_scale) * success_circle_progress
		color = Color.white
		color.a = a
		draw_circle(origin, (radius as float) * s, color)

func complete():
	for cap in capturables:
		connect("complete", cap, "_on_Loop_complete", [], CONNECT_ONESHOT)
	emit_signal("complete")
	$Timer.start(success_lifetime_sec)
	draw_success_circle = true
	

func _on_Player_loop_advance(value_rad):
	progress_rad += abs(value_rad)
	update() # Re-draw
	if progress_rad >= 2 * PI:
		complete()

func _on_Player_loop_cancel():
	$FadeTween.interpolate_method(self, "set_alpha", get_alpha(), 0.0, 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$FadeTween.start()

func _on_Timer_timeout():
	# Success lifetime over so fade out.
	$FadeTween.interpolate_method(self, "set_alpha", get_alpha(), 0.0, 3.0,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$FadeTween.start()

func _on_FadeTween_tween_completed(_object, _key):
	# Faded out so free
	queue_free()

func _on_Area2D_area_entered(area):
	# area is known to be a Capturable by collision mask
	capturables.append(area)

func _on_Area2D_area_exited(area):
	# area is known to be a Capturable by collision mask
	# This will probably never happen anyway but oh well
	capturables.erase(area)

# Getters and setters
func get_radius():
	return radius

func set_radius(value):
	radius = value
	$Area2D/CollisionShape2D.shape.set_radius(value)

func set_alpha(value):
	alpha = value
	update() # Re-draw with new alpha

func get_alpha():
	return alpha
