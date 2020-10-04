# LevelSelect.gd

extends Control

export(Resource) var level_list
var level_button_resource = preload("res://UI/MainMenu/LevelSelect/ButtonLevel.tscn")

func _ready():
	# Populate level grid
	for i in level_list.get_number_of_levels():
		var lb = level_button_resource.instance()
		$GridContainer.add_child(lb)
		lb.set_text(String(i + 1).pad_zeros(2))
		lb.connect("pressed", self, "_on_ButtonLevel_pressed", [i])

func _on_ButtonLevel_pressed(level):
	SceneTransition.fade(level_list.get_level(level), 0.2, 1.0)

func _on_ButtonBack_pressed():
	SceneTransition.instant("res://UI/MainMenu/MainMenu.tscn")
