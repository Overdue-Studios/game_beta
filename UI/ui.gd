extends Control

@onready var options = $Options
@onready var save_select = $Save_Select

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_select.exit_save.connect(_on_exit_save)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	pass

func _on_options_button_button_down() -> void:
	get_parent().get_node("Options").visible = true


func _on_exit_button_button_down() -> void:
	get_tree().quit()


func _on_play_button_button_down() -> void:
	save_select.visible = true
	save_select.grab_focus()
	
func _on_exit_save() -> void:
	save_select.visible = false
	$MarginContainer.visible = true
	self.visible = false
