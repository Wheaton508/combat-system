extends Button
class_name TargetButton

@export_group("Node References")
@export var combat_manager : CombatManager
@export var ui_manager : UIManager
@export var board_position : BoardPosition

var stored_unit : Unit


# =================================================================================================


func _on_visibility_changed() -> void:
	text = board_position.current_unit.unit_name
	if board_position.current_unit.incapacitated == true:
		disabled = true
	# if unit is not a valid target, also disable


func _on_pressed() -> void:
	combat_manager.current_unit.current_targets.append(board_position)
	
	if combat_manager.current_unit.current_position == Unit.Position.PRIMARY and combat_manager.player_secondary.current_unit.incapacitated == false:
		combat_manager.current_unit = combat_manager.player_secondary.current_unit
		ui_manager.proceed_menu("Action Select")
		print("Current unit is now " + str(combat_manager.current_unit))
	else:
		combat_manager.combat_setup()
		ui_manager.proceed_menu("Dialogue Box")
		pass
