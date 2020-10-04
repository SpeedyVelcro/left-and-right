# HealthBar.gd

extends Control

func set_progress(ratio):
	# Takes values between 0 and 1
	$ProgressBar.set_as_ratio(ratio)
