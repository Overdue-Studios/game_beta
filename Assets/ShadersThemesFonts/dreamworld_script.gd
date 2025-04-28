extends CanvasLayer

@onready var target := $ColorRect
@onready var shader_material := target.material as ShaderMaterial
@onready var playerPosition;
@onready var dreaming;

func _process(delta):
	shader_material.set_shader_parameter("scene_time", Time.get_ticks_msec() / 1000.0)
	shader_material.set_shader_parameter("player_position", get_parent().get_node("Player").global_position)
	shader_material.set_shader_parameter("viewport_size", get_viewport().get_visible_rect().size)
	shader_material.set_shader_parameter("radius", 0)
	if Input.is_action_just_pressed("world_switch") and !dreaming:
		dreaming = true
		shader_material.set_shader_parameter("dreaming", true)
		shader_material.set_shader_parameter("start_time", Time.get_ticks_msec() / 1000.0)
		print(shader_material.get_shader_parameter("dreaming"))
	elif Input.is_action_just_pressed("world_switch") and dreaming:
		dreaming = false
		shader_material.set_shader_parameter("dreaming", false)
		shader_material.set_shader_parameter("start_time", Time.get_ticks_msec() / 1000.0)
		print(shader_material.get_shader_parameter("dreaming"))
