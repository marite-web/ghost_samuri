extends CanvasLayer


func _on_restart_pressed():
	get_tree().paused = false
	print("restarted")
	get_tree().change_scene_to_file("res://Levels/test_scene.tscn")
	

func _on_quit_pressed():
	get_tree().quit()
