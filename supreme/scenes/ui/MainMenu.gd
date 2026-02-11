extends Control

@onready var continue_button = $CenterContainer/VBoxContainer/ContinueButton
@onready var new_game_button = $CenterContainer/VBoxContainer/NewGameButton
@onready var settings_button = $CenterContainer/VBoxContainer/SettingsButton
@onready var quit_button = $CenterContainer/VBoxContainer/QuitButton

func _ready():
	# Подключаем сигналы
	continue_button.pressed.connect(_on_continue_pressed)
	new_game_button.pressed.connect(_on_new_game_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# ВРЕМЕННО не работает:
	# update_texts()
	# GameManager.language_changed.connect(update_texts)
	# check_saved_game()
	
	# Временные тексты
	continue_button.text = "Продолжить"
	new_game_button.text = "Новая игра"
	settings_button.text = "Настройки"
	quit_button.text = "Выход"

# func update_texts():
#     continue_button.text = tr("menu_continue")
#     new_game_button.text = tr("menu_new_game")
#     settings_button.text = tr("menu_settings")
#     quit_button.text = tr("menu_quit")

# func check_saved_game():
#     continue_button.visible = GameManager.has_saved_game()

func _on_continue_pressed():
	# GameManager.load_saved_game()
	print("Continue pressed")

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/NewGameScreen.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/SettingsMenu.tscn")

func _on_quit_pressed():
	get_tree().quit()
