# LevelList.gd

extends Resource

export(Array, String) var levels = []

# Getters and setters
func get_level(num):
	return levels[num]
