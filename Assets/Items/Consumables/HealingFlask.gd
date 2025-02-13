class_name HealingFlask extends "..\\__item__.gd"

@onready var player = GameManager.player

@export var heal: int = 75
@export var max_heal: int = 75
@export var flask_level: int = 1

func level_flask():
	self.max_heal += self.flask_level * 5
	if self.heal != self.max_heal:
		self.heal = self.max_heal
		
	self.max_quantity += 1
	if self.quantity != self.max_quantity:
		self.quantity = self.max_quantity
		
		
func use_flask():
	if self.quantity == 0:
		return
		
	if self.player.hp != self.player.max_hp:
		if self.player.hp + self.heal > self.player.max_hp:
			self.player.hp += self.player.max_hp - self.player.hp
		else:
			self.player.hp += self.heal
		self.player.hp_bar.value = self.player.hp
	self.quantity -= 1
