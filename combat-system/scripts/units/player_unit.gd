extends Unit
class_name PlayerUnit

@export var stats: Stats


# =================================================================================================


func set_target(target_list : Array[EnemyUnit]):
	current_target = target_list.pick_random()
