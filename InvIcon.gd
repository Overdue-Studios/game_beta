"""extends TextureRect

func _get_drag_data(at_position):
	
	var data
	
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = texture
	drag_texture.rect_size = Vector2(100,100)
	
	set_drag_preview(drag_texture)
	
	return data
	
func _can_drop_data(at_position, data):
	
	return true
	return false
	
func _drop_data(at_position, data):
	pass
"""
