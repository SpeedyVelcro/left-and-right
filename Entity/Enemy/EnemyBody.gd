# EnemyBody.gd

extends KinematicBody2D

var path = null
var speed = 80
var path_points
var path_index = 0
var next_point_threshold = 1
var velocity = Vector2(0, 0)

func _physics_process(_delta):
	if is_path_assigned():
		var target = path_points[path_index]
		# Choose next point to go towards
		while get_position().distance_to(target) <= next_point_threshold:
			path_index += 1
			if path_index >= path_points.size():
				path_index %= path_points.size()
			target = path_points[path_index]
		# Calculate velocity and direction
		velocity = (target - get_position()).normalized() * speed
		var dir = velocity.angle()
		# Apply movement
		set_rotation(dir)
		velocity = move_and_slide(velocity)

func is_path_assigned():
	return path != null

# Getters and setters
func set_path(value):
	path = value
	path_points = path.get_curve().get_baked_points()

func get_path():
	return path
