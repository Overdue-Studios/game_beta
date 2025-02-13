extends Control


@onready var option_button: OptionButton = $HBoxContainer/OptionButton

const RESOLUTION_DICT: Dictionary = {
	"1920x1080": Vector2i(1920, 1080),
	"1280x720": Vector2i(1280, 720),
	"1024x768": Vector2i(1024, 768),
	"800x600": Vector2i(800, 600),
	"640x480": Vector2i(640, 480)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_resolution_items()
	option_button.item_selected.connect(_on_resolution_selected)

func add_resolution_items() -> void:
	for resolution in RESOLUTION_DICT:
		option_button.add_item(resolution)

func _on_resolution_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICT.values()[index])



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
