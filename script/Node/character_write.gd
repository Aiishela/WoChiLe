extends Control

@onready var pinyin_input: LineEdit = %Pinyin
@onready var option_buttons: Array = [
	%Character1,
	%Character2,
	%Character3
]
signal correct_choice
var correct_symbol: String
var characters = []

func _ready():
	self.visible = !self.visible
	var char_file = FileAccess.open("res://data/characters.json", FileAccess.READ)
	
	if char_file:
		var text = char_file.get_as_text()
		characters = JSON.parse_string(text)
		char_file.close()
		
	for button in option_buttons:
		button.pressed.connect(Callable(self, "_on_option_pressed").bind(button))

func _on_option_pressed(button):
	if button.text == correct_symbol:
		#emit_signal("correct_choice", button.text)
		WordInventory.add_word(button.text)
		print("Correct!")
	else:
		print("Wrong!")
		
	self.visible = !self.visible

func show_options():
	var matches = characters.filter(func(c): return c.pinyin == pinyin_input.text)
	if matches == []:
		self.visible = !self.visible
		return

	var correct = matches[ randi() % matches.size() ]
	var options = [correct]
	correct_symbol = correct.hanzi
	var others = characters.duplicate()
	others.erase(correct)
	others.shuffle()
	options.append(others[0])
	options.append(others[1])
	options.shuffle()
	
	var pos = 0
	for button in option_buttons:
		button.visible = true
		button.text = options[pos].hanzi
		pos += 1

func _on_pinyin_text_submitted(new_text: String) -> void:
	show_options()

const PINYIN_MAP = {
	"a1": "ā", "a2": "á", "a3": "ǎ", "a4": "à",
	"e1": "ē", "e2": "é", "e3": "ě", "e4": "è",
	"i1": "ī", "i2": "í", "i3": "ǐ", "i4": "ì",
	"o1": "ō", "o2": "ó", "o3": "ǒ", "o4": "ò",
	"u1": "ū", "u2": "ú", "u3": "ǔ", "u4": "ù",
	"ü1": "ǖ", "ü2": "ǘ", "ü3": "ǚ", "ü4": "ǜ"
}

func _on_pinyin_text_changed(new_text: String) -> void:
	for key in PINYIN_MAP.keys():
		if key in new_text:
			new_text = new_text.replace(key, PINYIN_MAP[key])
	pinyin_input.text = new_text
	pinyin_input.caret_column = new_text.length()

# --------------------------------------------------------
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("show_ui_character_write"):
		self.visible = !self.visible

func _on_visibility_changed() -> void:
	for button in option_buttons:
		button.visible = false
