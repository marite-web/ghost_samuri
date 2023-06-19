extends CharacterBody2D

@export var normal_speed : float = 150.0
@export var jump_velocity : float = -150.0
@export var double_jump_velocity : float = -100.0  
@export var stationary_dash : float = 1000.0
@export var moving_dash : float = 3000.0 
@export var dashlength : float = 0.3
const MAX_HEALTH : int = 100

@onready var dash = $dash
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var locked_animation : bool = false
var is_dashing : bool = false
var direction : Vector2 = Vector2.ZERO
var moving : bool = false
var health : int = MAX_HEALTH

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else: 
		has_double_jumped = false

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor(): #normal jump from floor
			velocity.y = jump_velocity
		elif not has_double_jumped:
			velocity.y = double_jump_velocity
			has_double_jumped = true
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity.x = direction.x * normal_speed
	else:
		velocity.x = move_toward(velocity.x, 0, normal_speed)
	
	if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		moving = true
	else:
		moving = false
	
	if Input.is_action_just_pressed("dash"):
		is_dashing = true
		animated_sprite.play("dash")
		health -= 10
		print(health)
		var turn;
		if animated_sprite.flip_h == false:
			turn = 1;
		else:
			turn = -1;
		if not moving: 
			dash.start_dash(dashlength)
			velocity.x = stationary_dash * turn
		else:
			dash.start_dash(dashlength)
			velocity.x = moving_dash * turn 
		is_dashing = false
 
	update_animation()
	move_and_slide()
	update_facing_direction()
	set_health_bar()
	
func update_animation():
	if not locked_animation: 
		if not is_dashing and Input.is_action_pressed("right") or Input.is_action_pressed("left") and not is_dashing:
			animated_sprite.play("run")
			
func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

func set_health_bar():
	$soulbar.value = health
