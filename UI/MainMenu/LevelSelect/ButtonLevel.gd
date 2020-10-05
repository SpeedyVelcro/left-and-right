# ButtonLevel.gd

extends Button

func _on_ButtonLevel_toggled(button_pressed):
	# This code ensures code ignores input when depressed
	if button_pressed:
		set_mouse_filter(MOUSE_FILTER_IGNORE)
	else:
		set_mouse_filter(MOUSE_FILTER_STOP)
