extends Control

@onready var title = $CenterContainer/VBoxContainer/Title
@onready var language_option = $CenterContainer/VBoxContainer/LanguageHBox/LanguageOption
@onready var sound_slider = $CenterContainer/VBoxContainer/SoundHBox/SoundSlider
@onready var fullscreen_check = $CenterContainer/VBoxContainer/FullscreenHBox/FullscreenCheckBox
@onready var back_button = $CenterContainer/VBoxContainer/BackButton

@onready var language_label = $CenterContainer/VBoxContainer/LanguageHBox/LanguageLabel
@onready var sound_label = $CenterContainer/VBoxContainer/SoundHBox/SoundLabel
@onready var fullscreen_label = $CenterContainer/VBoxContainer/FullscreenHBox/FullscreenLabel

func _ready():
	setup_controls()
	load_current_settings()
	update_texts()
	
	GameManager.language_changed.connect(_on_language_changed_signal)
	back_button.pressed.connect(_on_back_pressed)

func setup_controls():
	language_option.clear()
	language_option.add_item(tr("language_ru"), 0)
	language_option.set_item_metadata(0, "ru")
	language_option.add_item(tr("language_en"), 1)
	language_option.set_item_metadata(1, "en")
	
	language_option.item_selected.connect(_on_language_changed)
	sound_slider.value_changed.connect(_on_sound_volume_changed)
	fullscreen_check.toggled.connect(_on_fullscreen_changed)

func load_current_settings():
	sound_slider.value = GameManager.settings["sound_volume"]
	fullscreen_check.button_pressed = GameManager.settings["fullscreen"]
	
	var current_lang = GameManager.settings["language"]
	for i in range(language_option.item_count):
		if language_option.get_item_metadata(i) == current_lang:
			language_option.select(i)
			break

func update_texts():
	title.text = tr("settings_title")
	language_label.text = tr("settings_language")
	sound_label.text = tr("settings_sound")
	fullscreen_label.text = tr("settings_fullscreen")
	back_button.text = tr("menu_back")
	
	language_option.set_item_text(0, tr("language_ru"))
	language_option.set_item_text(1, tr("language_en"))

# Cсигнал (без параметров)
func _on_language_changed_signal():
	update_texts()

# Сигналы для кнопок (с параметром)
func _on_language_changed(index):
	var selected_lang = language_option.get_item_metadata(index)
	GameManager.set_language(selected_lang)

func _on_sound_volume_changed(value):
	GameManager.set_sound_volume(value)

func _on_fullscreen_changed(enabled):
	GameManager.settings["fullscreen"] = enabled
	GameManager.apply_settings()
	GameManager.save_settings()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
