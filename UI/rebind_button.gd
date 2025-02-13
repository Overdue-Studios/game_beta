extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button
@export var action : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()
	button.toggle_mode = true  # Enable toggle mode
	button.toggled.connect(_on_button_toggled) # Connect the signal in code
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_action_name() -> void:
	label.text = "Unnassigned"

	match action:
		"ui_up":
			label.text = "Up"
		"ui_down":
			label.text = "Down"
		"ui_left":
			label.text = "Left"
		"ui_right":
			label.text = "Right"

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)

	button.text = "%s" % action_keycode


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		button.text = "Press Key"
		set_process_unhandled_key_input(toggled_on)

		for i in get_tree().get_nodes_in_group("Control_Buttons"):
			if i.action != self.action:
				i.button.disabled = true
				i.set_process_unhandled_key_input(false)
	else:
		for i in get_tree().get_nodes_in_group("Control_Buttons"):
			if i.action != self.action:
				i.button.disabled = false
				i.set_process_unhandled_key_input(false)

		set_text_for_key()

func _unhandled_key_input(event: InputEvent) -> void:
	rebind_action_key(event)
	button.button_pressed = false

func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)

	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()