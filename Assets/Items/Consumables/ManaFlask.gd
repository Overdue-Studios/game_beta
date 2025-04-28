class_name ManaFlask extends HealingFlask

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
		
	if player.fp + self.heal > player.max_fp:
		player.fp += player.max_fp - player.fp
	else:
		player.fp += self.heal
	player.fp_bar.value = player.fp
	self.quantity -= 1
