class_name HealingFlask

@export var heal: int = 75
@export var max_heal: int = 75
@export var flask_level: int = 1
@export var quantity: int = 5

func __init__():
	self.heal = 75
	self.max_heal = 75
	self.flask_level = 1

func level_flask():
	self.max_heal += self.flask_level * 5
	if self.heal != self.max_heal:
		self.heal = self.max_heal
		
	self.max_quantity += 1
	if self.quantity != self.max_quantity:
		self.quantity = self.max_quantity
		
		
func use_flask(player):
	if self.quantity == 0:
		return
	if player.hp == player.max_hp:
		return
		
	if player.hp + self.heal > player.max_hp:
		player.hp += player.max_hp - player.hp
	else:
		player.hp += self.heal
	player.hp_bar.value = player.hp
	self.quantity -= 1
