# Player.gd

extends KinematicBody2D

export var steering_broken = false # If true, straight steer is inaccessible
var throttle = 0 # Integer. 0 is stationary. Positive picks from forward_speed
		# array, negative from reverse speed.
var acceleration = 8
var deceleration = 3
var brake = 8
var previous_steering = 0
var target_steering = 0
var steering = 0
var interpolating_steering = false
var steering_change_progress = 0
var steering_change_rate = 3
#var turn_speed = 0.03
var turn_radius = 64
var turn_velocity = 0
var velocity = Vector2(0, 0)
var speed = 0
var drag = 0.03
onready var loop_resource = preload("res://Entity/Player/Loop/Loop.tscn")
var loop

signal loop_cancel


func _physics_process(delta):
	velocity = Vector2(0, 0)
	
	# Drag
	var speed_sign = sign(speed)
	speed = abs(speed)
	speed -= speed * drag
	if speed <= 0:
		speed = 0
	speed *= speed_sign
	
	# Steering
	if Input.is_action_just_pressed("steer_left"):
		steer(-1)
	if Input.is_action_just_pressed("steer_right"):
		steer(1)
	if interpolating_steering:
		steering_change_progress += steering_change_rate * delta
		if steering_change_progress >= 1:
			interpolating_steering = false
			steering_change_progress = 0
			start_loop()
		else:
			steering = previous_steering + (target_steering - previous_steering) * steering_change_progress
	
	# Calculate and apply turn
	turn_velocity = perfect_turn_velocity()
	rotation += turn_velocity * delta
	
	# Update steering graphic
	if steering < -0.33:
		$AnimatedSprite.play("left")
	elif steering > 0.33:
		$AnimatedSprite.play("right")
	else:
		$AnimatedSprite.play("straight")
	
	# Vroom vroom
	if Input.is_action_pressed("accelerate"):
		speed += acceleration
	if Input.is_action_pressed("decelerate"):
		if speed > 0:
			speed -= brake
		else:
			speed -= deceleration
	var move_vec = Vector2(cos(get_rotation()), sin(get_rotation())) * speed
	
	# Finalise movement
	velocity += move_vec
	move_and_slide(velocity)

func start_loop():
	if target_steering == 0:
		return
	# Calculate loop position
	var loop_pos = Vector2(cos(get_global_rotation()), sin(get_global_rotation()))
	loop_pos *= turn_radius
	if target_steering < 0:
		loop_pos = loop_pos.rotated(-(PI / 2))
	if target_steering > 0:
		loop_pos = loop_pos.rotated(PI / 2)
	loop_pos += get_global_position()
	# Create loop
	if loop != null:
		cancel_loop()
	loop = loop_resource.instance()
	get_parent().add_child(loop)
	loop.set_global_position(loop_pos)

func cancel_loop():
	emit_signal("loop_cancel")
	# TODO: disconnect signals
	loop = null

func steer(direction):
	# Direction should be 1 or -1
	var original_steer = target_steering
	if direction == 0:
		return
	previous_steering = steering
	interpolating_steering = true
	if steering_broken:
		target_steering = direction
	else:
		target_steering += direction
		target_steering = clamp(target_steering, -1, 1)
	if original_steer != target_steering:
		cancel_loop()

func perfect_turn_velocity(steer = steering):
	# Returns turn velocity in radians per second required for a perfect
	# circular turn of exact radius turn_radius
	if speed == 0:
		return 0
	# Calculate the time a full loop would take for a constant circumference
	var expected_time = (2 * PI * turn_radius) / speed
	# Then calculate turn speed from time
	return steer * ((2 * PI) / expected_time)
