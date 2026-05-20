extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -500.0

# Health system
@export var max_health: int = 10
var current_health: int

@onready var health_bar = $HealthBar
@onready var health_label = $HealthLabel

func _ready() -> void:
	# Initialize health
	current_health = max_health
	update_health_display()
	# Add player to "player" group for easy detection
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Function to take damage
func take_damage(amount: int) -> void:
	current_health -= amount
	print("Player took ", amount, " damage! Health: ", current_health)
	update_health_display()
	
	# Check if player is dead
	if current_health <= 0:
		die()

# Function to heal
func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
	print("Player healed for ", amount, " health! Health: ", current_health)
	update_health_display()

# Update health display
func update_health_display() -> void:
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health
	
	if health_label:
		health_label.text = "Health: " + str(current_health) + "/" + str(max_health)

# Function called when player dies
func die() -> void:
	print("Player died!")
	# Add death logic here (respawn, game over screen, etc.)
	queue_free()
