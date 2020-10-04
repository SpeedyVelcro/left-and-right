# Level.gd

extends Node

export(int) var current_level = 1 # Starts at 1
export(Resource) var level_list
var time_elapsed_centisec = 0
var finished = false
var started = false

signal time_elapsed(time_sec)
signal finished

func _ready():
	for fin in get_tree().get_nodes_in_group("finish"):
		fin.connect("activated", self, "_on_Finish_activated", [], CONNECT_ONESHOT)

func _process(delta):
	if started and not finished:
		var t = 100 * delta
		time_elapsed_centisec += t
		emit_signal("time_elapsed", t)

func _on_Finish_activated():
	emit_signal("finished")
	finished = true
	$FinishTimer.start(2.0)

func _on_FinishTimer_timeout():
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

func _on_Player_first_move():
	started = true

func _on_Player_death():
	$DeathTimer.start(2.0)

func _on_DeathTimer_timeout():
	SceneTransition.fade(get_tree().get_current_scene().get_filename(), 1.0, 0.5)
