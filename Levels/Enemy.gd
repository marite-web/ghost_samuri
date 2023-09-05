extends Area2D

@export var move_velocity : float = 130.0
@export var move_direction : Vector2 
@onready var Player = get_node("/root/level_1/Player")
@onready var enemy = get_node("/root/level_1/Enemy/Bullet")
@onready var security = get_node("/root/level_1/Enemy/security/security_guard")

var can_fire = true
var bullet = preload("res://bullet.tscn")
var start_position : Vector2
var target_postition : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	target_postition = start_position + move_direction
	start_position = security.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (Player.in_enemy_space == true or Player.in_enemy_space_other == true) and can_fire == true: 
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = start_position
		security.play("shooting")
		get_parent().add_child(bullet_instance)
		print('shots fired')
		can_fire = false
		await get_tree().create_timer(2).timeout
		can_fire = true

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Collision")
		Player.souls -= 25
		global_position = start_position
		enemy.visible = false 
