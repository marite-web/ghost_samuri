extends Area2D

@export var move_velocity : float = 130.0
@export var move_direction : Vector2 
@onready var Player = get_node("/root/Test_Scene/Player")
@onready var Bullet = get_node("/root/Enemy")

var start_position : Vector2
var target_postition : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Player.in_enemy_space == true or Player.in_enemy_space_other == true: 
		_bullet_movement(delta)
	if Player.in_enemy_space == false or Player.in_enemy_space_other == false:
		get_node("/root/Test_Scene/Enemy/bullet_shape").disabled == true
		Bullet.visible == false

func _bullet_movement(delta):
	get_node("/root/Test_Scene/Enemy/bullet_shape").disabled == false
	Bullet.visible = true

	if Player.in_enemy_space_other == true:
		get_node("/root/Test_Scene/SecurityGuard2").scale.x = -1
		target_postition = start_position - move_direction
	elif Player.in_enemy_space_other == false:
		get_node("/root/Test_Scene/SecurityGuard2").scale.x = 1
		target_postition = start_position + move_direction

	if global_position == start_position:
		Bullet.visible = true
		global_position = global_position.move_toward(target_postition, move_velocity * delta)
	elif global_position == target_postition:
		Bullet.visible = false 
	global_position = start_position

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Collision")
		Player.souls -= 25
		global_position == start_position
		Bullet.visible = false 
