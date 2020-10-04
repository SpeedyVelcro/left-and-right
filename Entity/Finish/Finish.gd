# Finish.gd

extends StaticBody2D

signal activated

func _on_Capturable_captured():
	emit_signal("activated")
