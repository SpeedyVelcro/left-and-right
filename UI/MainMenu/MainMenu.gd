# MainMenu.gd

extends Control

func _on_ButtonPlay_pressed():
	SceneTransition.fade("res://Level/Instance/001.tscn", 0.2, 0.5)

func _on_ButtonLevelSelect_pressed():
	SceneTransition.instant("res://UI/MainMenu/LevelSelect/LevelSelect.tscn")

func _on_ButtonCredits_pressed():
	SceneTransition.instant("res://UI/MainMenu/Credits/Credits.tscn")

func _on_ButtonQuit_pressed():
	get_tree().quit()
