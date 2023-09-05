extends Area2D
@onready var animated_sprite1: AnimatedSprite2D = $sprite1
@onready var animated_sprite2: AnimatedSprite2D = $sprite2
@onready var player = get_node("/root/Test_Scene/Player")
@onready var collision = get_node("/root/Test_Scene/Exit/CollisionShape2D")
@onready var bar = get_node("/root/Test_Scene/Camera2D/Control/soulbar")
@onready var at_exit : bool = false

var end_position : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	end_position = animated_sprite2.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		get_tree().paused = true
		at_exit = true
		animated_sprite1.play("opening")
		animated_sprite2.play("opening")
		await get_tree().create_timer(1).timeout
		player.global_position = end_position
		bar.visible = false
		animated_sprite1.z_index = 13
		animated_sprite1.play("closing")
		animated_sprite2.play("closing")


