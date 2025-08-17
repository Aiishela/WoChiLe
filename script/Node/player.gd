extends CharacterBody2D

const SPEED: float = 50.0

# Reference to the AnimatedSprite2D node
@onready var player_animation: AnimatedSprite2D = %Animations
@onready var pinyin_input: LineEdit = %CharacterWrite/Pinyin

func _ready():
	add_to_group("Player")

func _physics_process(delta):
	if pinyin_input and pinyin_input.has_focus():
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var direction = Input.get_vector("move_left", "move_right","move_up","move_down")
	velocity = direction * SPEED
	move_and_slide()
	
	if direction.x != 0:
		player_animation.flip_h = direction.x < 0
		
	if velocity.length() > 0.0:
		player_animation.play("run")
	else:
		player_animation.play("idle") 
