extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimatedSprite2D")

var state = 0
var in_cover = false

func _ready():
	anim.play("idle")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = 0
	if Input.is_action_pressed("ui_right"):
		direction = 1
	elif Input.is_action_pressed("ui_left"):
		direction = -1

	if direction == -1:
		anim.flip_h = true
	elif direction == 1:
		anim.flip_h = false

	if direction:
		velocity.x = direction * SPEED
		anim.play("running")
	else:
		if anim.animation != "crouching" and not Input.is_action_pressed("ui_right"):
			anim.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_cover_detection_body_entered(body):
	if body.name == "crate1":
		in_cover = true
		print("Entered cover")

func _on_cover_detection_body_exited(body):
	if body.name == "crate1":
		in_cover = false
		print("Exited cover")

func _input(event):
	if event.is_action_pressed("ui_right") and in_cover:
		velocity.x = 0
	elif event.is_action_released("ui_right") and in_cover:
		velocity.x = 0
