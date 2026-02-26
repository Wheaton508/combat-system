extends Unit
class_name EnemyUnit


# =================================================================================================


func _ready() -> void:
	super()
	
	if level > 1:
		autolevel(level - 1)

func autolevel(levels_to_give: int):
	while levels_to_give > 0:
		hp += increase_stat(hp_growth)
		atk += increase_stat(atk_growth)
		def += increase_stat(def_growth)
		mag += increase_stat(mag_growth)
		mag_def += increase_stat(mag_def_growth)
		spd_growth += increase_stat(spd_growth)
		levels_to_give -= 1

func random_move(target_list : Array[PlayerUnit]):
	current_action = Action.MOVE
	
	var valid_move = false
	while valid_move == false:
		current_move = moves.pick_random()
		if current_move != null:
			valid_move = true

func select_move(): # This ai will get a massive overhaul at some point. I just want to get it functioning for now
	# select a random move
	while current_move != null:
		var temp_move : Move = moves.pick_random()
		if temp_move != null:
			current_move = temp_move
	# set targeting based on the move's targeting type. Make sure it can't target incapacitated guys
	# yay!
	pass
