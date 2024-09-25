extends NinePatchRect

signal _button_down

# Called when the node enters the scene tree for the first time.
func _ready():
	$Name.text = get_parent().get_parent().name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_button_down():
	close()

func close():
	get_tree().paused = false
	_button_down.emit()
	#self.get_parent().remove_child(self)
	GameManager.nomove = false
	get_parent().get_parent().interactable = true
	get_parent().queue_free()
