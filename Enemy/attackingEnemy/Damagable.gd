extends Node

class_name Damagable 

@onready var Player = get_node("/root/level_1/Player")
@onready var Sprite = get_node("/root/level_1/testingattack/Sprite")
@export var health : float = 20 


func hit(damage : float): #sprite):
	#var Sprite = sprite
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
		
		

# I love you sm -k
