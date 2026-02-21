extends Unit
class_name EnemyUnit


# =================================================================================================


# i need some sort of spawn function that takes in unit level and set the unit's stats based on their class's growth rates

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
