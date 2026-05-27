extends CharacterBody2D

# Movement settings - easily customizable
@export var movement_speed: float = 400.0
@export var jump_velocity: float = -500.0
@export var double_jump_velocity: float = -400.0
@export var gravity_multiplier: float = 1.0

# Health settings - easily customizable
@export var max_health: int = 100
@export var current_health: int = 100

# Jump tracking
var jumps_remaining: int = 0
var max_jumps: int = 2  # 1 ground jump + 1 double jump

# Debug/signals
signal health_changed(new_health: int)
signal player_died

func _ready() -> void:
	# Initialize health
	current_health = max_health
	jumps_remaining = max_jumps
	
	# Connect hitbox signal if it exists
	if has_node("HitBox"):
		$HitBox.area_entered.connect(_on_hitbox_area_entered)

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * gravity_multiplier * delta
	else:
		# Reset jumps when on floor
		jumps_remaining = max_jumps
	
	# Handle jump and double jump
	if Input.is_action_just_pressed("ui_accept"):
		if jumps_remaining > 0:
			velocity.y = jump_velocity if jumps_remaining == max_jumps else double_jump_velocity
			jumps_remaining -= 1
	
	# Get the input direction and handle the movement/deceleration
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
	
	move_and_slide()

func take_damage(damage: int) -> void:
	"""Reduce health when enemy hits the player"""
	current_health -= damage
	health_changed.emit(current_health)
	
	print("Player took ", damage, " damage! Health: ", current_health, "/", max_health)
	
	if current_health <= 0:
		current_health = 0
		player_died.emit()
		print("Player has died!")
		# You can add death logic here (animation, respawn, etc.)

func heal(amount: int) -> void:
	"""Restore player health"""
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health)
	print("Player healed for ", amount, " health! Health: ", current_health, "/", max_health)

func get_health() -> int:
	"""Return current health"""
	return current_health

func _on_hitbox_area_entered(area: Area2D) -> void:
	"""Called when enemy hitbox touches the player"""
	# Check if the colliding area is an enemy hitbox
	if area.is_in_group("enemy_hitbox") or area.name == "EnemyHitBox":
		# The damage amount should be passed from the enemy script
		# or you can define a default damage value here
		var damage = 10
		if area.has_meta("damage"):
			damage = area.get_meta("damage")
		take_damage(damage)
