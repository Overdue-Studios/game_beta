extends TileMap
@onready var shader = preload("res://Levels/dreamworld.gdshader")
@onready var shader_material = ShaderMaterial.new()
@onready var dreaming = false
# Called when the node enters the scene tree for the first time.
func _ready():
	shader_material.shader = shader


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("world_switch") and !dreaming:
		self.material = shader_material
		dreaming = true
		print("dreaming")
	elif Input.is_action_just_pressed("world_switch") and dreaming:
		self.material = null
		print("not dreaming")
		dreaming = false
