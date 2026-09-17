extends CharacterBody2D

const SPEED := 300.0
const JUMP_VELOCITY := -400.0

var score: int = 0
var double_jump: bool = true
@export var ui: Node

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor() and not double_jump:
		double_jump = true

	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor() or double_jump:
			if not is_on_floor():
				double_jump = false
			velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	move_and_slide()
