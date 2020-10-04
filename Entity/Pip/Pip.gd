# Pip.gd

extends Node2D

signal collected

func _ready():
	$HoverAnimationPlayer.play("hover")
	$HoverAnimationPlayer.seek(randf())


func _on_Capturable_captured():
	# TODO: animation, sound effect
	emit_signal("collected")
	queue_free()
