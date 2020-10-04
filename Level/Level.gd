# Level.gd

extends Node

export(int) var current_level = 1 # Starts at 1
export(Resource) var level_list

func _ready():
	for fin in get_tree().get_nodes_in_group("finish"):
		fin.connect("activated", self, "_on_Finish_activated", [], CONNECT_ONESHOT)

func _on_Finish_activated():
	next_level()

func next_level():
	if current_level >= level_list.get_number_of_levels():
		# Final level so back to main menu
		SceneTransition.fade("res://UI/MainMenu/MainMenu.tscn")
	else:
		# Go to next level
		var next = level_list.get_level(current_level) # Inherently next level as
				# current_level starts from 1
		SceneTransition.fade(next)
