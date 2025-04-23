extends Control
@onready var MainMenu = get_parent().get_node("MainMenu")
@onready var Options = get_parent().get_node("Options")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc_menu") and self.visible == true and get_parent().get_parent().get_parent().get_node("Level") != null and Options.visible == false and MainMenu.visible == false:
		self.visible = false
		GameManager.pause(false)
	elif Input.is_action_just_pressed("esc_menu") and self.visible == false and get_parent().get_parent().get_parent().get_node("Level") != null:
		self.visible = true
		GameManager.pause(true)
		Options.visible = false
		MainMenu.visible = false


func _on_exit_button_pressed() -> void:
	GameManager.save("save1")
	get_parent().get_parent().get_parent().get_node("Level").queue_free()
	self.visible = false
	MainMenu.visible = true

func _on_continue_button_pressed() -> void:
	GameManager.pause(false)
	self.visible = false


func _on_options_button_button_down() -> void:
	Options.visible = true
