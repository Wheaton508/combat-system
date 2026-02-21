extends Button
class_name TargetButton

@export var combat_manager : CombatManager
# 0 for Primary, 1 for Secondary, and 2 for Backline. This is used literally only here.
@export var position_id : int
@export var is_player : bool

var stored_unit : Unit


# =================================================================================================


func _on_visibility_changed() -> void:
	var position_to_find : Unit.Position
	
	if is_visible_in_tree():
		match position_id:
			0:
				position_to_find = Unit.Position.PRIMARY
			1:
				position_to_find = Unit.Position.SECONDARY
			2:
				position_to_find = Unit.Position.BACKLINE
			_:
				print("ERROR. No valid unit.")
		
		stored_unit = combat_manager.get_unit_at_position(position_to_find, is_player)
		text = stored_unit.unit_name
		if stored_unit.incapacitated == true:
			disabled = true
		# if unit is not a valid target, also disable


func _on_pressed() -> void:
	combat_manager.current_unit.current_target = stored_unit
	
	if combat_manager.current_unit.current_position == Unit.Position.PRIMARY:
		# set up move selection for secondary unit
		pass
	else:
		# move to combat proceedings
		pass
