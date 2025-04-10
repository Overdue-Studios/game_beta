extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.nomove = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_exit_button_pressed() -> void:
	GameManager.save("save1")
	get_parent().get_parent().get_node("Level").queue_free()
	GameManager.camera.priority = 1
	self.queue_free()

func _on_continue_button_pressed() -> void:
	GameManager.nomove = false
	self.queue_free()
