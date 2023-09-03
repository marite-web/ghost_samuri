extends CollisionShape2D

class_name attackable

@onready var Sprite = get_node("/root/Test_Scene/Enemy/Security/security_guard")
@onready var Player = get_node("/root/Test_Scene/Player")
@export var health : float = 20 


func hit_2(damage : float):
	print(health)
	print(Player.souls)
	health -= damage
	
	Sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	Sprite.modulate = Color.WHITE
	
	if(health <= 0):
		get_parent().queue_free()
		if Player.souls >= 90:
			Player.souls += 100 - Player.souls
		else:
			Player.souls += 10
		print(Player.souls)
