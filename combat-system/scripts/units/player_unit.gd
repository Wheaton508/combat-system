extends Unit
class_name PlayerUnit


# =================================================================================================


func set_target(target_list : Array[EnemyUnit]):
	current_target = target_list.pick_random()
