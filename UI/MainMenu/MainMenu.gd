# MainMenu.gd

extends Control

func _on_ButtonPlay_pressed():
	SceneTransition.fade("res://Level/Instance/001.tscn")

func _on_ButtonLevelSelect_pressed():
	SceneTransition.fade("res://UI/MainMenu/LevelSelect/LevelSelect.tscn")

func _on_ButtonQuit_pressed():
	get_tree().quit()