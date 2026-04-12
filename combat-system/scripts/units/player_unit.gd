extends Unit
class_name PlayerUnit


# =================================================================================================


# Ideally, I'd like for this to happen actually on the level up - not sure if we need to show the stat increase to the player? Dunno. Probably should actually
func level_up():
	level += 1
	
	# Reset/Roll over EXP
	
	# Set stats based on growths
	var hp_increase = increase_stat(hp_growth)
	hp += hp_increase
	current_hp += hp_increase
	
	atk += increase_stat(atk_growth)
	def += increase_stat(def_growth)
	mag += increase_stat(mag_growth)
	res += increase_stat(res_growth)
	spd_growth += increase_stat(spd_growth)
