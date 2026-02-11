extends Node

func _ready():
	load_translations()

func load_translations():
	var translation_file = "res://translations/translations.csv"
	
	if not FileAccess.file_exists(translation_file):
		push_error("Translation file not found!")
		return
	
	var file = FileAccess.open(translation_file, FileAccess.READ)
	
	# ЭТО НЕ ОШИБКА, но как минимум с ней всё работает прото жалуеться
	var header = file.get_csv_line()
	
	var keys = []
	var en_translations = {}
	var ru_translations = {}
	
	while not file.eof_reached():
		var line = file.get_csv_line()
		if line.size() >= 3:
			var key = line[0].strip_edges()
			var en_text = line[1].strip_edges()
			var ru_text = line[2].strip_edges()
			
			if key and en_text and ru_text:
				en_translations[key] = en_text
				ru_translations[key] = ru_text
	
	file.close()
	
	create_translation_resource("en", en_translations)    # исправит язык
	create_translation_resource("ru", ru_translations)    # исправит язык
	
	print("Translations loaded successfully")

func create_translation_resource(locale, translations):
	var translation = Translation.new()
	translation.locale = locale
	
	for key in translations.keys():
		translation.add_message(key, translations[key])
	
	TranslationServer.add_translation(translation)
