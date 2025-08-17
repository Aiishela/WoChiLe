extends Area2D

@onready var sprite = $AnimatedSprite2D
@export var sprite_name: String
@export var instance_id: String = ""

var hanzi: String
var pinyin: String
var meaning: String
var player_inside: bool = false

func _ready():
	if instance_id == "":
		instance_id = sprite_name + "_" + str(global_position)
		
	if GameState.is_collected(instance_id):
		queue_free()
		return
		
	add_to_group("Pickups")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	var word_info = WordInventory.get_character_info_from_id(sprite_name)
	if word_info:
		hanzi = word_info.hanzi
		pinyin = word_info.pinyin
		meaning = word_info.meaning
		
		if !WordInventory.has_word(hanzi + "_" + pinyin):
			$Label.text = hanzi + " (" + pinyin + ")"
		
		var frames_path = "res://scene/World Elements/" + sprite_name + ".tres"
		if ResourceLoader.exists(frames_path):
			var frames = load(frames_path) as SpriteFrames
			if frames:
				sprite.sprite_frames = frames
				sprite.play("default")
		else:
			print("Missing sprite frames for: ", sprite_name)

	else:
		print("Word_element_pickup didn't find info on", sprite_name)
		
func _on_body_entered(body: Node) -> void:
	print("Entered ", sprite_name)
	if body.is_in_group("Player"):
		player_inside = true

func _on_body_exited(body: Node) -> void:
	print("Exited ", sprite_name)
	if body.is_in_group("Player"):
		player_inside = false

#func _process(delta: float) -> void:
#	if player_inside:
#		print("Player is still inside")
		
# ------------------------------------------------------------------------------

func collect():
	if sprite.sprite_frames.has_animation("disappear"):
		$Label.visible = false
		GameState.mark_collected(instance_id)
		sprite.play("disappear")
		sprite.animation_finished.connect(queue_free, CONNECT_ONE_SHOT)
	else:
		queue_free()
