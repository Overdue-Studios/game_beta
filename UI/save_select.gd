extends Control

signal exit_save

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc_menu") and self.visible == true:
		self.visible = false

func _on_button_s_1_button_down() -> void:
	GameManager.load_save("save1")
	exit_save.emit()

func _on_button_s_2_button_down() -> void:
	GameManager.load_save("save2")
	exit_save.emit()
	
	
func _on_button_s_3_button_down() -> void:
	GameManager.load_save("save3")
	exit_save.emit()
	
func _on_exit_button_button_down() -> void:
	self.visible =  false
