extends Unit
class_name PlayerUnit


# =================================================================================================


func _ready() -> void:
	if not initialized:
		# set stats equal to the base stats of their class +/ up to two or three
		# set random name
		# set initialized to true
		pass
	pass

func set_target(target_list : Array[EnemyUnit]):
	current_target = target_list.pick_random()
