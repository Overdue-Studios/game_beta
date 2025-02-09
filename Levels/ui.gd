extends Control

@onready var options = $Options

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options.exit_options.connect(_on_exit_options)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	SceneSwap.change_scene("res://Levels/TestLevel/map_root.tscn")

func _on_options_button_button_down() -> void:
	options.visible = true
	options.grab_focus()
	$MarginContainer.visible = false


func _on_exit_button_button_down() -> void:
	get_tree().quit()

func _on_exit_options() -> void:
	options.visible = false
	$MarginContainer.visible = true



