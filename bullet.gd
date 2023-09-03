extends Area2D

@export var speed = 150
@onready var Player = get_node("/root/Test_Scene/Player")
@onready var guard = get_node("/root/Test_Scene/Enemy/security/security_guard")
@onready var bul: AnimatedSprite2D = $AnimatedSprite2D

var x = 0
var bullet_gone : bool = false

func _ready():
	set_as_top_level(true)

func _process(delta):
	if x == 1:
		position += (Vector2.RIGHT*speed*-1) * delta
	elif x == -1:
		position += (Vector2.RIGHT*speed) * delta
	elif Player.in_enemy_space == true:
		x = 1
	elif Player.in_enemy_space_other == true:
		x = -1

func _physics_process(delta):
	if Player.in_enemy_space == true:
		guard.flip_h = false
		bul.flip_h = true
	elif Player.in_enemy_space_other == true:
		guard.flip_h = true
	
	await get_tree().create_timer(0.01).timeout
	set_physics_process(false)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	queue_free()
	if body.is_in_group("Swords"):
		queue_free()
	elif body.is_in_group("Player"):
		Player.souls -= 25
	
