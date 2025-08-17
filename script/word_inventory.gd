extends Node

const SAVE_FILE = "user://word_inventory.json"

var all_characters = [] 
var unlocked_characters = []
@export var character_entry_scene: PackedScene  # drag CharacterEntry.tscn here in the Inspector

func _ready():
	var file = FileAccess.open("res://data/characters.json", FileAccess.READ)
	if file:
		var text = file.get_as_text()
		all_characters = JSON.parse_string(text)
		file.close()

	load_inventory()

func add_word(hanzi: String):
	if not has_word(hanzi):
		unlocked_characters.append(hanzi)
		save_inventory()

func has_word(hanzi: String) -> bool:
	return hanzi in unlocked_characters

func get_locked_words() -> Array:
	return all_characters.filter(func(c): return c.hanzi not in unlocked_characters)

func save_inventory():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		var data = {
			"unlocked": unlocked_characters
		}
		file.store_string(JSON.stringify(data))
		file.close()

func load_inventory():
	if not FileAccess.file_exists(SAVE_FILE):
		return
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		var data = JSON.parse_string(text)
		if typeof(data) == TYPE_DICTIONARY and "unlocked" in data:
			unlocked_characters = data["unlocked"]
		file.close()
	
func get_character_info(symbol: String) -> Dictionary:
	var matches = all_characters.filter(func(c): return c.hanzi == symbol)
	if matches.size() > 0:
		return matches[0]
	return {}

func get_character_info_from_id(id: String) -> Dictionary:
	var matches = all_characters.filter(func(c): return c.id == id)
	if matches.size() > 0:
		return matches[0]
	return {}
