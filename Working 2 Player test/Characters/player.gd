extends CharacterBody2D

signal dead

@export var normal_speed : float = 150.0
@export var jump_velocity : float = -150.0
@export var double_jump_velocity : float = -100.0  
@export var stationary_dash : float = 1000.0
@export var moving_dash : float = 3000.0 
@export var dashlength : float = 0.3
@export var fallen_distance : Vector2
const MAX_SOUL : int = 100


@onready var dash = $dash
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer = $soultimer2
@onready var bar = get_node("/root/Test_Scene/Camera2D/Control/soulbar")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var locked_animation : bool = false
var is_dashing : bool = false
var direction : Vector2 = Vector2.ZERO
var moving : bool = false
var souls : int = MAX_SOUL 

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
		souls -= 10
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
 
	set_soul_bar()
	update_animation()
	move_and_slide()
	update_facing_direction()

func _ready():
	bar.value = MAX_SOUL

func update_animation():
	if not locked_animation: 
		if not is_dashing and Input.is_action_pressed("right") or Input.is_action_pressed("left") and not is_dashing:
			animated_sprite.play("run")
		elif is_dashing:
			animated_sprite.play("dash")
		else:
			animated_sprite.play("idle")

func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

func end_game():
	get_tree().quit()

func set_soul_bar():
	bar.value = souls
	if souls <= 0:
		end_game()

func _on_soultimer_timeout():
	souls -=5

