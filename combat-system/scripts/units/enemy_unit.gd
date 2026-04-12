extends Unit
class_name EnemyUnit

enum AI_Type {RANDOM, SMART}

@export var ai_type : AI_Type


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
		res += increase_stat(res_growth)
		spd_growth += increase_stat(spd_growth)
		levels_to_give -= 1
	
	current_hp = hp

func select_move():
	match ai_type:
		AI_Type.RANDOM:
			while current_move == null:
				var temp_move : Move = moves.pick_random()
				if temp_move != null:
					current_move = temp_move
		_:
			print("ERROR. Invalid AI type for " + unit_name + ".")
	
	set_targeting(current_move)

func set_targeting(move : Move):
	match move.targeting_type:
		Move.Targeting_Type.SINGLE:
			# For now, choose randomly between the two. Eventually, pick highest damage.
			var random = randi_range(0, 1)
			if random == 0:
				current_targets.append(combat_manager.player_primary)
			else:
				current_targets.append(combat_manager.player_secondary)
		Move.Targeting_Type.SPREAD:
			current_targets.append(combat_manager.player_primary)
			current_targets.append(combat_manager.player_secondary)
		Move.Targeting_Type.SELF:
			if current_position == Position.PRIMARY:
				current_targets.append(combat_manager.enemy_primary)
			elif current_position == Position.SECONDARY:
				current_targets.append(combat_manager.enemy_secondary)
			else:
				print("ERROR. " + unit_name + " is attempting to attack from the Backline position.")
		Move.Targeting_Type.ALLY:
			if current_position == Position.PRIMARY:
				current_targets.append(combat_manager.enemy_secondary)
			elif current_position == Position.SECONDARY:
				current_targets.append(combat_manager.enemy_primary)
			else:
				print("ERROR. " + unit_name + " is attempting to attack from the Backline position.")
		Move.Targeting_Type.TEAM:
			current_targets.append(combat_manager.enemy_primary)
			current_targets.append(combat_manager.enemy_secondary)
		Move.Targeting_Type.FIELD:
			current_targets.append(combat_manager.player_primary)
			current_targets.append(combat_manager.player_secondary)
			
			if current_position == Position.PRIMARY:
				current_targets.append(combat_manager.enemy_secondary)
			elif current_position == Position.SECONDARY:
				current_targets.append(combat_manager.enemy_primary)
			else:
				print("ERROR. " + unit_name + " is attempting to attack from the Backline position.")
		_:
			print("ERROR. Invalid targeting type for " + unit_name + "'s " + move.name)
	pass
