# EnemyOld.gd
# Add a path to follow as a child of this node.
# Not that this node isn't the enemy, it's the node that manages it. The enemy
# (as in the kinematic body) is a child of this node.

extends Node2D

func _ready():
	var path_found = false
	for child in get_children():
		if child is Path2D:
			path_found = true
			$EnemyBody.set_path(child)
			break
	assert(path_found)
