extends CharacterBody2D

# Customizable settings
@export var detection_radius: float = 300.0  # How far the enemy can detect the player
@export var follow_speed: float = 200.0      # How fast the enemy moves toward player
@export var jump_velocity: float = -400.0    # Upward velocity when jumping
@export var gravity_strength: float = 1.0    # Multiplier for gravity
@export var damage_amount: int = 10          # Damage dealt to player on hit
@export var jump_cooldown: float = 1.0       # Seconds between jump attempts

var player: CharacterBody2D = null
var gravity: float = 0.0
var can_jump: bool = true
var jump_timer: float = 0.0

func _ready() -> void:
	# Find the player in the scene
	player = get_tree().root.get_child(0).find_child("player", true, false)
	if player == null:
		print("couldn't find player")
	gravity = get_gravity().y

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * gravity_strength * delta
	else:
		# Reset vertical velocity when on floor to stop bouncing
		if velocity.y > 0:
			velocity.y = 0
	
	# Check if player is in detection radius
	if player != null:
		var distance_to_player = global_position.distance_to(player.global_position)
		
		if distance_to_player <= detection_radius:
			# Player detected - follow them
			var direction_to_player = sign(player.global_position.x - global_position.x)
			velocity.x = direction_to_player * follow_speed
			
			# Jump if player is above us and we're on the floor
			if player.global_position.y < global_position.y - 50 and is_on_floor() and can_jump:
				velocity.y = jump_velocity
				can_jump = false
				jump_timer = jump_cooldown
		else:
			# Player not detected - stop moving
			velocity.x = 0
	else:
		velocity.x = 0
	
	# Handle jump cooldown
	if not can_jump:
		jump_timer -= delta
		if jump_timer <= 0:
			can_jump = true
	
	move_and_slide()

func take_damage(damage: int) -> void:
	# You can add effects here like knockback, animation, or health tracking
	print("Enemy hit player for ", damage, " damage!")

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "player_collision" or area.is_in_group("player"):
		# Deal damage to player
		if player != null and player.has_method("take_damage"):
			player.take_damage(damage_amount)
		take_damage(0)  # Optional: add knockback or other effects here
