extends Control

@onready var collected_words_container = $CollectedWords/GridContainer
@export var character_entry_scene: PackedScene 
@onready var character_information = $CharacterInformation
@onready var hanzi_label = character_information.get_node("Hanzi") as Label
@onready var pinyin_label = character_information.get_node("Pinyin") as Label
@onready var meaning_label = character_information.get_node("Meaning") as Label
@onready var object_animated = character_information.get_node("Control").get_child(0) as AnimatedSprite2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("show_ui_tablet"):
		print("Show tablet")
		self.visible = !self.visible

func _ready() -> void:
	visible = false
	hanzi_label.text = ""
	pinyin_label.text = ""
	meaning_label.text = ""
	
	load_inventory_display()

func load_inventory_display() -> void:
	for child in collected_words_container.get_children():
		child.queue_free()
		
	for symbol in WordInventory.unlocked_characters:
		var entry: Button = character_entry_scene.instantiate()
		entry.text = symbol
		entry.name = "CharacterEntry_" + symbol
		collected_words_container.add_child(entry)

		entry.pressed.connect(_on_character_entry_pressed.bind(symbol))

func _on_character_entry_pressed(symbol: String) -> void:
	var info = WordInventory.get_character_info(symbol.split("_")[0])
	hanzi_label.text = info.hanzi
	pinyin_label.text = info.pinyin
	meaning_label.text = info.meaning

	if object_animated and object_animated.is_inside_tree():
		object_animated.queue_free()
		
	if info.has("scene") and info["scene"] != "":
		var scene_res = load(info["scene"])
		
		if scene_res:
			var new_obj = scene_res.instantiate()
			character_information.get_node("Control").add_child(new_obj)
			
			#if new_obj is AnimatedSprite2D:
			#	new_obj.scale = Vector2(50, 50) / new_obj.texture.get_size()
			
			new_obj.play("default")
			new_obj.position = Vector2.ZERO
			object_animated = new_obj

	
	print("You clicked on: ", symbol)

func _on_character_write_character_collected(hanzi) -> void:
	if collected_words_container.has_node("CharacterEntry_" + hanzi):
		return

	var entry: Button = character_entry_scene.instantiate()
	entry.text = hanzi
	entry.name = "CharacterEntry_" + hanzi
	collected_words_container.add_child(entry)

	entry.pressed.connect(_on_character_entry_pressed.bind(hanzi))
	print("Added ",hanzi," to inventory.")
