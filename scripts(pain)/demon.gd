extends CharacterBody2D

# Detection and tracking
@export var detection_range: float = 300.0
@export var player_node_path: NodePath = NodePath("../Player")
var player: Node2D
var is_player_detected: bool = false

# Movement (horizontal only)
@export var move_speed: float = 200.0
@export var acceleration: float = 500.0
@export var friction: float = 400.0

# Jumping
@export var jump_velocity: float = -400.0
@export var height_difference_threshold: float = 50.0
@export var jump_cooldown: float = 0.5
var can_jump: bool = true

# Damage system
@export var damage_amount: int = 10
@export var damage_cooldown: float = 1.0
var can_damage: bool = true

# Gravity
var gravity: float = get_gravity().y

# Velocity
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Get reference to player node
	player = get_node(player_node_path)
	# Add demon to "enemy" group for easy detection
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Check if player is in detection range
	check_player_detection()
	
	# Update behavior based on detection
	if is_player_detected:
		track_player(delta)
		check_for_jump()
	else:
		apply_friction(delta)
	
	# Apply velocity and move
	velocity = move_and_slide(velocity)
	
	# Check for collision with player
	check_collision_with_player()

func check_player_detection() -> void:
	"""Check if player is within detection range"""
	if player == null:
		is_player_detected = false
		return
	
	var distance_to_player: float = global_position.distance_to(player.global_position)
	is_player_detected = distance_to_player <= detection_range

func track_player(delta: float) -> void:
	"""Move towards the player horizontally only (ground movement)"""
	if player == null:
		return
	
	# Only move horizontally towards player
	var horizontal_direction: float = sign(player.global_position.x - global_position.x)
	velocity.x = move_toward(velocity.x, horizontal_direction * move_speed, acceleration * delta)

func apply_friction(delta: float) -> void:
	"""Apply friction when player is not detected"""
	velocity.x = move_toward(velocity.x, 0, friction * delta)

func check_for_jump() -> void:
	"""Check if player is higher than demon and jump towards them"""
	if player == null or not is_on_floor() or not can_jump:
		return
	
	# Check if player is higher than demon
	var height_difference: float = player.global_position.y - global_position.y
	
	if height_difference < -height_difference_threshold:
		jump()

func jump() -> void:
	"""Perform a jump towards the player"""
	velocity.y = jump_velocity
	can_jump = false
	
	# Start jump cooldown
	await get_tree().create_timer(jump_cooldown).timeout
	can_jump = true

func check_collision_with_player() -> void:
	"""Check if demon is colliding with player and deal damage"""
	if player == null or not can_damage:
		return
	
	# Get all colliding bodies
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() == player:
			# Deal damage to player
			player.take_damage(damage_amount)
			can_damage = false
			# Start cooldown
			await get_tree().create_timer(damage_cooldown).timeout
			can_damage = true

func draw_detection_range() -> void:
	"""Optional: Override _draw to visualize detection range"""
	draw_circle(Vector2.ZERO, detection_range, Color(1, 0, 0, 0.2))

func _draw() -> void:
	"""Visualize detection range (debug)"""
	draw_circle(Vector2.ZERO, detection_range, Color(1, 0, 0, 0.2))

func _process(delta: float) -> void:
	# Redraw detection range every frame
	queue_redraw()
