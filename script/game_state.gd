extends Node

const SAVE_FILE = "user://game_state.json"

var collected_instances: Array = []

func _ready():
	load_data()

func load_data():
	if not FileAccess.file_exists(SAVE_FILE):
		return
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		var data = JSON.parse_string(text)
		if typeof(data) == TYPE_DICTIONARY and "collected" in data:
			collected_instances = data["collected"]
		file.close()

func save_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		var data = { "collected": collected_instances }
		file.store_string(JSON.stringify(data))
		file.close()

func mark_collected(id: String):
	if not collected_instances.has(id):
		collected_instances.append(id)
		save_data() 

func is_collected(id: String) -> bool:
	return collected_instances.has(id)
