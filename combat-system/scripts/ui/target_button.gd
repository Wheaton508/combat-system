extends Button
class_name TargetButton

@export_group("Node References")
@export var combat_manager : CombatManager
@export var action_menu : Control
@export var board_position : BoardPosition

var stored_unit : Unit


# =================================================================================================


func _on_visibility_changed() -> void:
	text = board_position.current_unit.unit_name
	if board_position.current_unit.incapacitated == true:
		disabled = true
	# if unit is not a valid target, also disable


func _on_pressed() -> void:
	# Instead of getting the unit, make current_targets a list of strings, and then swicth on strings and get_unit_at_pos depending on that for targeting. solves any issues regarding targets moving or dying
	combat_manager.current_unit.current_targets.append(board_position)
	
	if combat_manager.current_unit.current_position == Unit.Position.PRIMARY:
		combat_manager.current_unit = combat_manager.get_unit_at_position(Unit.Position.SECONDARY, true)
		action_menu.visible = true
		get_parent().visible = false
	else:
		combat_manager.combat_setup()
		get_parent().visible = false
		pass
