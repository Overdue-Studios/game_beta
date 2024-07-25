extends TextureRect

var dragging = false
var drag_offset = Vector2.ZERO
var mouse_over = false
signal drag_start
signal drag_stop

func _ready():
	add_to_group("InvItems")
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if mouse_over:
				print("being dragged")
				dragging = true
				drag_offset = position - get_global_mouse_position()
				emit_signal("drag_start", get_parent())
		elif dragging == true:
			emit_signal("drag_stop", get_parent())
			dragging = false

	elif event is InputEventMouseMotion and dragging:
		position = get_global_mouse_position() + drag_offset

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
