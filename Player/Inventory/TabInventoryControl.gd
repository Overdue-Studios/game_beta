extends NinePatchRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("inventory"):
		close()
		
func _on_button_button_down():
	close()
	
func close():
	get_tree().paused = false
	GameManager.nomove = false
	get_parent().queue_free()
