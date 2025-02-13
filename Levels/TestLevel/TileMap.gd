extends TileMap
@onready var shader = preload("res://Assets/ShadersThemesFonts/dreamworld.gdshader")
@onready var shader_material = ShaderMaterial.new()
@onready var dreaming = false
# Called when the node enters the scene tree for the first time.
func _ready():
	shader_material.shader = shader

