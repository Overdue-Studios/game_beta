extends TextureRect

var dragging = false
var drag_offset = Vector2.ZERO
signal drag_start
signal drag_stop

func _ready():
	add_to_group("InvItems")
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if mouse_over():
				print("being dragged")
				dragging = true
				drag_offset = position - get_global_mouse_position()
				emit_signal("drag_start", self)
		elif dragging == true:
			emit_signal("drag_stop", get_parent())
			dragging = false

	elif event is InputEventMouseMotion and dragging:
		position = get_global_mouse_position() + drag_offset

func mouse_over():
	var inv_grid = get_parent().get_parent()
	if inv_grid.hovered_slot != null and get_parent() == inv_grid.hovered_slot:
		return true
	return false
