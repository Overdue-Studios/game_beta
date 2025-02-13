extends Control

@onready var options = $Options
@onready var save_select = $Save_Select

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options.exit_options.connect(_on_exit_options)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	pass

func _on_options_button_button_down() -> void:
	options.visible = true
	options.grab_focus()
	$MarginContainer.visible = false


func _on_exit_button_button_down() -> void:
	get_tree().quit()

func _on_exit_options() -> void:
	options.visible = false
	$MarginContainer.visible = true


func _on_play_button_button_down() -> void:
	save_select.visible = true
	save_select.grab_focus()
	$MarginContainer.visible = false
