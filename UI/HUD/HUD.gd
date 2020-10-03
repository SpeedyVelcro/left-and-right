# HUD.gd

extends CanvasLayer

func _on_Player_steer_left():
	$Controller.steer_left()

func _on_Player_steer_straight():
	$Controller.steer_straight()

func _on_Player_steer_right():
	$Controller.steer_right()

func _on_Player_throttle_forward():
	$Controller.throttle_forward()

func _on_Player_throttle_stop():
	$Controller.throttle_stop()

func _on_Player_throttle_reverse():
	$Controller.throttle_reverse()


func _on_ControllerArea_body_entered(_body):
	# Collision mask means only player can trigger this
	$Controller.hide()

func _on_ControllerArea_body_exited(_body):
	# Collision mask means only player can trigger this
	$Controller.show()
