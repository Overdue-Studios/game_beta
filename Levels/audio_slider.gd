extends Control


@onready var slider: HSlider = $HBoxContainer/HSlider
@onready var name_label: Label = $HBoxContainer/Audio_Name
@onready var audio_num : Label = $HBoxContainer/Label

@export_enum("Master", "Music", "SFX") var bus_name : String

var bus_index: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slider.value_changed.connect(_on_slider_value_changed)
	get_bus_name()
	set_name_label()
	set_slider_value()



func set_name_label() -> void:
	name_label.text = str(bus_name) + " Volume"

func set_audio_num() -> void:
	audio_num.text = str(slider.value*100) + "%"



func _on_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	set_audio_num()

func get_bus_name() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

func set_slider_value() -> void:
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_audio_num()
