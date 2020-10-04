# SceneTransition.gd

extends Node

func instant(scene: String):
	get_tree().change_scene(scene)

func fade(scene : String, out_time_sec : float = 1.0, in_time_sec : float = 1.0):
	# TODO: actually write a fade lol
	get_tree().change_scene(scene)
