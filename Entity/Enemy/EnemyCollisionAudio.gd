# EnemyCollisionAudio.gd
# This is a stupid fucking hack for a bullshit problem that makes me want to kms
# There is literally no fucking reason this has to be a separate node, why is
# this so difficult?

extends AudioStreamPlayer

func _ready():
	print("enemy collision audio node created")
	play()

func _on_EnemyCollisionAudio_finished():
	print("enemy collision audio node queued for freeing")
	#queue_free()
