extends CharacterBody2D

# Detection and tracking
@export var detection_range: float = 300.0
@export var player_node_path: NodePath = NodePath("../Player")
var player: Node2D
var is_player_detected: bool = false

# Movement
@export var move_speed: float = 200.0
@export var acceleration: float = 500.0
@export var friction: float = 400.0

# Velocity
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Get reference to player node
	player = get_node(player_node_path)

func _physics_process(delta: float) -> void:
	# Check if player is in detection range
	check_player_detection()
	
	# Update behavior based on detection
	if is_player_detected:
		track_player(delta)
	else:
		apply_friction(delta)
	
	# Apply velocity and move
	velocity = move_and_slide(velocity)

func check_player_detection() -> void:
	"""Check if player is within detection range"""
	if player == null:
		is_player_detected = false
		return
	
	var distance_to_player: float = global_position.distance_to(player.global_position)
	is_player_detected = distance_to_player <= detection_range

func track_player(delta: float) -> void:
	"""Move towards the player when detected"""
	if player == null:
		return
	
	var direction: Vector2 = (player.global_position - global_position).normalized()
	velocity = velocity.move_toward(direction * move_speed, acceleration * delta)

func apply_friction(delta: float) -> void:
	"""Apply friction when player is not detected"""
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func draw_detection_range() -> void:
	"""Optional: Override _draw to visualize detection range"""
	draw_circle(Vector2.ZERO, detection_range, Color(1, 0, 0, 0.2))

func _draw() -> void:
	"""Visualize detection range (debug)"""
	draw_circle(Vector2.ZERO, detection_range, Color(1, 0, 0, 0.2))

# Optional: Add visual feedback when player is detected
func _process(delta: float) -> void:
	# Redraw detection range every frame
	queue_redraw()
