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
@onready var timer = $soultimer
@onready var bar = get_node("/root/Test_Scene/Camera2D2/Control/soulbar")
@onready var otherbar = get_node("/root/Test_Scene/Camera2D/Control/soulbar")
@onready var OTHERPLAYER = get_node("/root/Test_Scene/Player")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var locked_animation : bool = false
var is_dashing : bool = false
var direction : Vector2 = Vector2.ZERO
var moving : bool = false
var souls : int = MAX_SOUL 

var udp := PacketPeerUDP.new()
var connected = false
func _ready():
	OTHERPLAYER.position.x = 0
	OTHERPLAYER.position.y = 0
	bar.value = MAX_SOUL
	#----------------------------127.0.0.1 = Local Testing--------------------------------------------------
	udp.connect_to_host("127.0.0.1", 6053)
	#udp.connect_to_host("222.152.70.199", 50069) #(Port: 50069 - 50420)
	#--------------------------222.152.70.199 = Online Multiplayer------------------------------------------

var lobby_name := "BRUH_PALACE"
var data := ''
var other_goto
var other_positions = 0
var FOLLOW_SPEED: int = 47
var animationstage := 'idle'


func _physics_process(delta):

		
	var packet := (str(position.x) + "{!!!!!!DIVIDER!!!!!!}" + str(position.y)) +"{!!!!!!DIVIDER!!!!!!}"+( lobby_name ) + "{!!!!!!DIVIDER!!!!!!}" + str(animated_sprite.flip_h) + "{!!!!!!DIVIDER!!!!!!}" + str(animationstage) +"{!!!!!!DIVIDER!!!!!!}" + str(souls) + "{!!!!!!DIVIDER!!!!!!}" + str(velocity.x) + "{!!!!!!DIVIDER!!!!!!}" + str(velocity.y)
		
	udp.put_packet( (packet).to_utf8_buffer())
	if udp.get_available_packet_count() > 0:
		data = (udp.get_packet().get_string_from_utf8())
	
	if 'p1' in data:
		#print('p1')
		other_positions = data.split('p1')
	if 'p2' in data:
		#print('p2')
		other_positions = data.split('p2')
		
	if udp.get_available_packet_count() > 0:
		#Handling x,y (1,2)
		other_goto = Vector2( int(other_positions[0]) , int(other_positions[1])  ) 
		OTHERPLAYER.position = OTHERPLAYER.position.lerp(other_goto, delta * FOLLOW_SPEED)
		#Handling Flip.h (3)
		if other_positions[2] == 'true':
			OTHERPLAYER.animated_sprite.flip_h = true
		if other_positions[2] == 'false':
			OTHERPLAYER.animated_sprite.flip_h = false
		#Handling Animation stage (4)
		animated_sprite.play(other_positions[3])
		#Handling Soulbar Value (5)
		otherbar.value = int(other_positions[4] )
		#Handling Velocity x,y (6,7)
		OTHERPLAYER.velocity.x = int(other_positions[5])
		OTHERPLAYER.velocity.y = int(other_positions[6])
		
		
		
		
		
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else: 
		has_double_jumped = false

	# Handle Jump.
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor(): #normal jump from floor
			velocity.y = jump_velocity
		elif not has_double_jumped:
			velocity.y = double_jump_velocity
			has_double_jumped = true
	
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity.x = direction.x * normal_speed
	else:
		velocity.x = move_toward(velocity.x, 0, normal_speed)
	
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		moving = true
	else:
		moving = false
	
	if Input.is_action_just_pressed("ui_down"):
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



func update_animation():
	if not locked_animation: 
		if not is_dashing and Input.is_action_pressed("right") or Input.is_action_pressed("left") and not is_dashing:
			animated_sprite.play("run")
			animationstage = 'run'
		elif is_dashing:
			animated_sprite.play("dash")
			animationstage = 'dash'
		else:
			animated_sprite.play("idle")
			animationstage = 'idle'

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

