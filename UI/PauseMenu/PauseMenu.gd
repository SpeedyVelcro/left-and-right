# PauseMenu.gd

extends CanvasLayer

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if get_tree().is_paused():
			unpause()
		else:
			pause()

func pause():
	get_tree().set_pause(true)
	$Visual.set_visible(true)

func unpause():
	get_tree().set_pause(false)
	$Visual.set_visible(false)

func _on_ButtonResume_pressed():
	unpause()

func _on_ButtonQuit_pressed():
	get_tree().set_pause(false)
	SceneTransition.fade("res://UI/MainMenu/MainMenu.tscn")
