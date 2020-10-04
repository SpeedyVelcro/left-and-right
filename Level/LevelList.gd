# LevelList.gd

extends Resource

export(Array, String) var levels = []

# Getters and setters
func get_level(num):
	while (num >= levels.size()):
		num -= levels.size()
	return levels[num]

func get_number_of_levels():
	return levels.size()
