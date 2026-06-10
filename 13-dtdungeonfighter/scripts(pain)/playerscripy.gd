extends CharacterBody2D

# Movement variables
var speed = 400.0
var acceleration = 500.0
var friction = 500.0

# Gravity and jumping
var gravity = 800.0
var jump_force = -400.0
var double_jump_force = -350.0

# Jump state tracking
var is_jumping = false
var can_double_jump = false

func _physics_process(delta):
	# Get input
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	
	# Apply horizontal movement
	if input_vector.x != 0:
		velocity.x = move_toward(velocity.x, input_vector.x * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Reset jump state when touching ground
		is_jumping = false
		can_double_jump = true
	
	# Handle jumping
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			# First jump
			velocity.y = jump_force
			is_jumping = true
		elif can_double_jump:
			# Double jump
			velocity.y = double_jump_force
			can_double_jump = false
	
	# Move the character
	move_and_slide()
