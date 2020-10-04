# Player.gd

extends KinematicBody2D

export var steering_broken = false # If true, straight steer is inaccessible
var throttle = 0 # Integer. 0 is stationary. Positive picks from forward_speed
		# array, negative from reverse speed.
var acceleration = 480
var deceleration = 180
var brake = 480
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
var drag = 1.8
onready var loop_resource = preload("res://Entity/Player/Loop/Loop.tscn")
var loop
var max_health = 100
var health = max_health

signal loop_cancel
signal loop_advance(value_rad)
signal death
signal health_changed(health, max_health)
# Steering signals
signal steer_left
signal steer_right
signal steer_straight
# Throttle signals
signal throttle_forward
signal throttle_reverse
signal throttle_stop

func _ready():
	emit_signal("health_changed", health, max_health)

func _physics_process(delta):
	velocity = Vector2(0, 0)
	
	# Drag
	var speed_sign = sign(speed)
	speed = abs(speed)
	speed -= speed * drag * delta
	if speed <= 0:
		speed = 0
	speed *= speed_sign
	
	# Vroom vroom
	var throttle_touched
	if Input.is_action_pressed("accelerate"):
		speed += acceleration * delta
		emit_signal("throttle_forward")
		throttle_touched = true
	if Input.is_action_pressed("decelerate"):
		if speed > 0:
			speed -= brake * delta
		else:
			speed -= deceleration * delta
		emit_signal("throttle_reverse")
		throttle_touched = true
	if not throttle_touched:
		emit_signal("throttle_stop")
	var move_vec = Vector2(cos(get_rotation()), sin(get_rotation())) * speed
	
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
			steering = target_steering
			start_loop()
		else:
			steering = previous_steering + (target_steering - previous_steering) * steering_change_progress
	
	# Calculate and apply turn
	turn_velocity = perfect_turn_velocity()
	rotation += turn_velocity * delta
	emit_signal("loop_advance", abs(turn_velocity * delta))
	
	# Update steering graphic
	if steering < -0.33:
		$AnimatedSprite.play("left")
	elif steering > 0.33:
		$AnimatedSprite.play("right")
	else:
		$AnimatedSprite.play("straight")
	
	# Update loop according to speed
	if speed > 0 and loop == null and not interpolating_steering:
		start_loop()
	elif speed < 0 and loop != null:
		cancel_loop()
	
	# Finalise movement
	velocity += move_vec
	move_and_slide(velocity)
	
	# Collision
	if get_slide_count() > 0:
		# Loop is now inaccurate so cancel
		cancel_loop()
		# Take damage
		var dam = abs(speed) - 70
		dam = max(dam, 0)
		dam *= 0.2
		take_damage(dam)
		# Bounce away
		speed *= -0.8

func take_damage(amount):
	set_health(get_health() - amount)

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
	# Set its values
	loop.starting_angle = get_global_position().angle_to_point(loop.get_global_position())
	loop.radius = turn_radius
	loop.direction = target_steering
	# Hook up
	connect("loop_cancel", loop, "_on_Player_loop_cancel")
	connect("loop_advance", loop, "_on_Player_loop_advance")
	loop.connect("complete", self, "_on_Loop_complete")

func cancel_loop():
	if loop != null:
		emit_signal("loop_cancel")
		forget_loop()

func forget_loop():
	disconnect("loop_cancel", loop, "_on_Player_loop_cancel")
	disconnect("loop_advance", loop, "_on_Player_loop_advance")
	loop.disconnect("complete", self, "_on_Loop_complete")
	loop = null

func steer(direction):
	# Direction should be 1 or -1
	var original_steer = target_steering
	if direction == 0:
		return
	if steering_broken:
		target_steering = direction
	else:
		target_steering += direction
		target_steering = clamp(target_steering, -1, 1)
	if original_steer != target_steering:
		cancel_loop()
		previous_steering = steering
		interpolating_steering = true
	# Emit signal
	match target_steering:
		-1:
			emit_signal("steer_left")
		0:
			emit_signal("steer_straight")
		1:
			emit_signal("steer_right")

func perfect_turn_velocity(steer = steering):
	# Returns turn velocity in radians per second required for a perfect
	# circular turn of exact radius turn_radius
	if speed == 0:
		return 0
	# Calculate the time a full loop would take for a constant circumference
	var expected_time = (2 * PI * turn_radius) / speed
	# Then calculate turn speed from time
	return steer * ((2 * PI) / expected_time)

func _on_Loop_complete():
	forget_loop()
	# WARNING: I suspect if the player slows down at exactly the right frame
	# this may cause an inaccurate loop because there are no checks here.
	start_loop()

# Getters and setters
func get_health():
	return health

func set_health(value):
	health = value
	if health <= 0:
		print("You died!")
		emit_signal("death")
	health = clamp(health, 0, max_health)
	emit_signal("health_changed", health, max_health)
	print(health)
