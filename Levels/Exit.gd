extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_node("/root/Test_Scene/Player")
@onready var bar = get_node("/root/Test_scene/Camera2D/Control/soulbar")
@onready var at_exit : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	at_exit = true
	print("at exit")
	animated_sprite.play("opening")

func _on_body_exited(body):
	at_exit = false
	animated_sprite.play("closing")


