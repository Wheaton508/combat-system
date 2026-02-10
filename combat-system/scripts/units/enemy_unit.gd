extends Unit
class_name EnemyUnit

@export var stats : Stats


# =================================================================================================


func random_move(target_list : Array[PlayerUnit]):
	current_action = Action.ATTACK
	
	var valid_move = false
	while valid_move == false:
		current_move = stats.moves.pick_random()
		if current_move != null:
			valid_move = true
	
	current_target = target_list.pick_random()
