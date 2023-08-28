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
const Game_Over_Screen = preload("res://UI/game_over_screen.tscn")

@onready var dash = $dash
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer = $soultimer
@onready var bar = get_node("/root/Test_Scene/Camera2D/Control/soulbar")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var locked_animation : bool = false
var is_dashing : bool = false
var attacking : bool = false
var direction : Vector2 = Vector2.ZERO
var moving : bool = false
var souls : int = MAX_SOUL 
var in_enemy_space : bool = false
var in_enemy_space_other : bool = false

func _physics_process(delta):
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y < 0:
			animated_sprite.play("jump")
		elif velocity.y > 0:
			animated_sprite.play("fall")
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

	set_soul_bar()
	update_animation()
	move_and_slide()
	update_facing_direction()

func _ready():
	z_index = 100
	bar.value = MAX_SOUL
	get_tree().paused = false

func update_animation():
	get_node("/root/Test_Scene/Player/Sword/sword_collision").disabled = true
	get_node("/root/Test_Scene/Player/Sword2/sword_collision2").disabled = true
	if attacking == true:
		animated_sprite.play("attack")
		print("egg")
	elif Input.is_action_just_pressed("attack"):
		attacking = true
		enable_hitbox()
	elif is_dashing == true:
		animated_sprite.play("dash")
	elif Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		animated_sprite.play("run")

func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

func end_game():
	#get_tree().paused = true
	var game_over = Game_Over_Screen.instantiate()
	add_child(game_over)

func set_soul_bar():
	bar.value = souls
	if souls > 100:
		souls = MAX_SOUL
	if souls <= 0:
		end_game()
		get_tree().paused = true


func _on_soultimer_timeout():
	souls -=5
	print(souls)

func _on_animated_sprite_2d_animation_finished():
	is_dashing = false
	attacking = false
	animated_sprite.play("idle")
	get_node("/root/Test_Scene/Player/Sword/sword_collision").disabled = true
	get_node("/root/Test_Scene/Player/Sword2/sword_collision2").disabled = true

func enable_hitbox():
	if animated_sprite.flip_h == false:
		get_node("/root/Test_Scene/Player/Sword2/sword_collision2").disabled = false
	elif animated_sprite.flip_h == true: 
		get_node("/root/Test_Scene/Player/Sword/sword_collision").disabled = false
	
func _on_enemy_space_body_entered(body):
	in_enemy_space = true 
	print("In enemy Space")

func _on_enemy_space_body_exited(body):
	in_enemy_space = false
	print("Left enemy Space")

func _on_enemy_space_other_body_entered(body):
	in_enemy_space_other = true
	print(body)
	print("In other enemy Space")

func _on_enemy_space_other_body_exited(body):
	in_enemy_space_other = false
	print("Left other enemy Space")
