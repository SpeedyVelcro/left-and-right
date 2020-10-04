# Level.gd

extends Node

export(int) var current_level = 0
export(Resource) var level_list

func _ready():
	for fin in get_tree().get_nodes_in_group("finish"):
		fin.connect("activated", self, "_on_Finish_activated", [], CONNECT_ONESHOT)

func _on_Finish_activated():
	next_level()

func next_level():
	var next = level_list.get_level(current_level + 1)
	SceneTransition.fade(next)
