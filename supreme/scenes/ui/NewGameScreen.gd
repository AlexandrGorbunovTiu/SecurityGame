extends Control

@onready var loading_label = $CenterContainer/VBoxContainer/LoadingLabel
@onready var progress_bar = $CenterContainer/VBoxContainer/ProgressBar

func _ready():
	start_new_game_sequence()

func start_new_game_sequence():
	# Имитация загрузки 1%
	await simulate_loading()
	
	# Переход к игре
	transition_to_game()

func simulate_loading():
	var progress = 0.0
	while progress < 1.0:
		progress += 0.02
		progress_bar.value = progress
		loading_label.text = "Загрузка... " + str(int(progress * 100)) + "%"
		await get_tree().create_timer(0.05).timeout

func transition_to_game():
	# Закиним суда позже саму игровую сцену
	get_tree().change_scene_to_file("res://scenes/game/World2D.tscn")
