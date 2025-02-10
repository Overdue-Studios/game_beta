extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_s_1_button_down() -> void:
	GameManager.load_save("save1")
	GameManager.camera.priority = 5

func _on_button_s_2_button_down() -> void:
	GameManager.load_save("save2")	
	GameManager.camera.priority = 5
	
func _on_button_s_3_button_down() -> void:
	GameManager.load_save("save3")
	GameManager.camera.priority = 5
