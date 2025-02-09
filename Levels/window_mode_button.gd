extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

const WINDOW_MODES: Array[String] = [
	"Windowed",
	"Fullscreen",
	"Borderless Fullscreen"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_window_mode_items()
	option_button.item_selected.connect(_on_item_selected)

func add_window_mode_items() -> void:
	for window_mode in WINDOW_MODES:
		option_button.add_item(window_mode)

func _on_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
