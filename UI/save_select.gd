extends Control

func _on_button_s_1_button_down() -> void:
	GameManager.load_save("save1")
	GameManager.camera.priority = 5

func _on_button_s_2_button_down() -> void:
	GameManager.load_save("save2")
	GameManager.camera.priority = 5
	
func _on_button_s_3_button_down() -> void:
	GameManager.load_save("save3")
	GameManager.camera.priority = 5
