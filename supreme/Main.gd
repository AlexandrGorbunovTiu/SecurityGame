extends Node

func _ready():
	# Ждем один кадр чтобы избежать ошибки 
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
