extends Node

signal language_changed()
signal sound_volume_changed(volume)
signal settings_loaded

var settings = {
	"language": "ru",
	"sound_volume": 0.8,
	"fullscreen": true
}

func _ready():
	load_translations()  
	load_settings()
	apply_settings()
	print("GameManager loaded!")

# ДОБАВИТЬ ЭТУ ФУНКЦИЮ:
func load_translations():
	var csv_content = """key,en,ru
menu_play,Play,Играть
menu_continue,Continue,Продолжить
menu_new_game,New Game,Новая игра
menu_settings,Settings,Настройки
menu_quit,Quit,Выход
menu_back,Back,Назад
menu_title,My 2D Game,Моя 2D Игра
settings_title,Settings,Настройки
settings_language,Language,Язык
settings_sound,Sound Volume,Громкость звука
settings_music,Music Volume,Громкость музыки
settings_fullscreen,Fullscreen,Полный экран
settings_resolution,Resolution,Разрешение
language_ru,Russian,Русский
language_en,English,Английский"""
	
	# Создаем перевады из CSV строки
	var lines = csv_content.split("\n")
	var headers = lines[0].split(",")
	
	var en_translations = {}
	var ru_translations = {}
	
	for i in range(1, lines.size()):
		var line = lines[i].strip_edges()
		if line == "":
			continue
			
		var values = line.split(",")
		if values.size() >= 3:
			var key = values[0]
			en_translations[key] = values[1]
			ru_translations[key] = values[2]
	
	create_translation_resource("en", en_translations)
	create_translation_resource("ru", ru_translations)
	
	print("Translations loaded: ", en_translations.size(), " keys")

func create_translation_resource(locale, translations):
	var translation = Translation.new()
	translation.locale = locale
	
	for key in translations.keys():
		translation.add_message(key, translations[key])
	
	TranslationServer.add_translation(translation)

func load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		for key in settings.keys():
			settings[key] = config.get_value("settings", key, settings[key])
		print("Settings loaded")
	else:
		save_settings()
	settings_loaded.emit()

func save_settings():
	var config = ConfigFile.new()
	for key in settings.keys():
		config.set_value("settings", key, settings[key])
	config.save("user://settings.cfg")

func apply_settings():
	TranslationServer.set_locale(settings["language"])
	
	# Громкость
	var master_bus = AudioServer.get_bus_index("Master")
	if master_bus != -1:
		AudioServer.set_bus_volume_db(master_bus, linear_to_db(settings["sound_volume"]))
	
	# Полный экран не работает если не настроит в настройках
	if settings["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	language_changed.emit()
	sound_volume_changed.emit(settings["sound_volume"])

# Смена языка        нужно исправит изменения языка в языке
func set_language(lang):
	if lang in ["ru", "en"]:
		settings["language"] = lang
		apply_settings()
		save_settings()
		print("Language changed to: ", lang)

func set_sound_volume(volume):
	settings["sound_volume"] = clamp(volume, 0.0, 1.0)
	apply_settings()
	save_settings()

func has_saved_game() -> bool:
	return false  # Временно

func load_saved_game():
	print("Loading saved game...")
