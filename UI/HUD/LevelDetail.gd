# LevelDetail.gd

extends Control

export(Resource) var level_list

func update_level(level_number):
	var txt = "Level "
	txt += String(level_number + 1)
	txt += "\n"
	txt += level_list.get_caption(level_number)
	$Label.set_text(txt)
