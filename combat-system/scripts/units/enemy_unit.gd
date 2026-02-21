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
	
	current_target = target_list.pick_random()
