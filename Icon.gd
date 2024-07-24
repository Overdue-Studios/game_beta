extends TextureRect



var dragging = false
var drag_offset = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if is_mouse_over():
				dragging = true
				drag_offset = global_position - event.global_position
		else:
			dragging = false

	elif event is InputEventMouseMotion and dragging:
		global_position = event.global_position + drag_offset

func is_mouse_over() -> bool:
	var mouse_pos = get_global_mouse_position()
	var rect = Rect2(-texture.get_size() * 0.5, texture.get_size())
	return rect.has_point(mouse_pos)
