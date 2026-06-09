extends CharacterBody2D

# Movement variables
var speed = 100.0
var chase_speed = 200.0
var acceleration = 300.0
var friction = 300.0

# Gravity
var gravity = 800.0

# Patrol behavior
var patrol_direction = 1  # 1 for right, -1 for left
var patrol_distance = 200.0
var starting_position = Vector2.ZERO
var is_patrolling = true

# Chase behavior
var player = null
var is_chasing = false

func _ready():
	starting_position = global_position

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	
	# Determine movement based on state
	if is_chasing and player:
		# Chase the player
		var direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * chase_speed
	elif is_patrolling:
		# Patrol movement
		velocity.x = patrol_direction * speed
		
		# Check if reached patrol boundary
		if abs(global_position.x - starting_position.x) >= patrol_distance:
			patrol_direction *= -1  # Change direction
	
	# Move the enemy
	move_and_slide()

# Called when player enters detection area (Area2D signal)
func _on_detection_area_entered(area):
	if area.name == "Player" or area.is_in_group("player"):
		player = area.get_parent()  # Get the player CharacterBody2D
		is_patrolling = false
		is_chasing = true
		print("Enemy detected player! Chasing...")

# Called when player leaves detection area
func _on_detection_area_exited(area):
	if area.name == "Player" or area.is_in_group("player"):
		player = null
		is_patrolling = true
		is_chasing = false
		print("Enemy lost sight of player! Resuming patrol...")
