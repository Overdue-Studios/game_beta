extends Resource
class_name ItemResource

#Default item variables
@export var name : String
@export var id : int
@export var stackable : bool = false
@export var max_stack_size : int = 1
enum ItemType {Generic, Consumable, Quest, Equipment}
@export var type : ItemType
@export var texture : Texture
