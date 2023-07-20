extends Node

class_name Damagable 

@onready var Sprite = get_node("/root/Test_Scene/testingattack/Sprite")
@onready var Player = get_node("/root/Test_Scene/Player")
@export var health : float = 20 


func hit(damage : float):
	print(health)
	print(Player.souls)
	health -= damage
	
	Sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	Sprite.modulate = Color.WHITE
	
	if(health <= 0):
		get_parent().queue_free()
		Player.souls += 10
		print(Player.souls)
		

# I love you sm -k
