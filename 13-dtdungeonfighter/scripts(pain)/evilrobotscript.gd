extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DETECTION_RANGE = 300.0
const PATROL_SPEED = 100.0

var player: CharacterBody2D = null
var is_patrolling = false
var patrol_direction = 1  # 1 for right, -1 for left
var player_detected = false


func _ready() -> void:
	# Find the player node
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		player = player_nodes[0]
	else:
		print("Warning: Player not found! Make sure player is in 'player' group or adjust the path.")


func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Check if player is in detection range
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)
		player_detected = distance_to_player < DETECTION_RANGE
	else:
		player_detected = false

	# Enemy movement: chase player if detected, otherwise stay still
	if player_detected and player:
		# Chase the player when detected
		var player_direction = sign(player.global_position.x - global_position.x)
		velocity.x = player_direction * SPEED
	else:
		# No movement when player is not detected
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
