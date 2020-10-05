# Pip.gd

extends Node2D

signal collected

func _ready():
	$HoverAnimationPlayer.play("hover")
	$HoverAnimationPlayer.seek(randf())


func _on_Capturable_captured():
	# TODO: animation, sound effect
	emit_signal("collected")
	$CapturePlayer.play()
	$Capturable.set_active(false)
	$Visual.set_visible(false)
	$ShadowSprite.set_visible(false)

func _on_CapturePlayer_finished():
	queue_free()
