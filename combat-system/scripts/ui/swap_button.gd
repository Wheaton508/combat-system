extends Button
class_name SwapButton

@export_group("Node References")
@export var combat_manager : CombatManager
@export var ui_manager : UIManager

# =================================================================================================

func _on_pressed():
	combat_manager.current_unit.current_action = Unit.Action.SWAP
	to_next_phase()

func to_next_phase():
	# RN I think this gets fucked up if unit swaps because current_unit is technically in backline. Take a look at that
	if combat_manager.current_unit.current_position == Unit.Position.PRIMARY and combat_manager.player_secondary.current_unit.incapacitated == false:
		combat_manager.current_unit = combat_manager.player_secondary.current_unit
		ui_manager.proceed_menu("Action Select")
	else:
		ui_manager.proceed_menu("Dialogue Box")
		combat_manager.combat_setup()
		
