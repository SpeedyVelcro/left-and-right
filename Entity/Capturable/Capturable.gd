# Capturable.gd

extends Area2D

signal captured

func _on_Loop_complete():
	emit_signal("captured")
