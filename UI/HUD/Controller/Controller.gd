# Controller.gd

extends Control

func steer_left():
	$Visual/SteerSprite.play("left")

func steer_straight():
	$Visual/SteerSprite.play("straight")

func steer_right():
	$Visual/SteerSprite.play("right")

func throttle_forward():
	$Visual/ThrottleSprite.play("forward")

func throttle_stop():
	$Visual/ThrottleSprite.play("stop")

func throttle_reverse():
	$Visual/ThrottleSprite.play("reverse")
