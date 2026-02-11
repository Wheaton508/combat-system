extends Button
class_name MoveButton

@export var combat_manager : CombatManager
@export var info_panel : MoveInfoPanel
@export var move_id : int

var stored_move : Move

# =================================================================================================


func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		if combat_manager.current_unit.moves[move_id] != null:
			stored_move = combat_manager.current_unit.moves[move_id]
			text = stored_move.short_name
		else:
			disabled = true
		pass

func _on_mouse_entered() -> void:
	if not disabled:
		info_panel.move_name.text = stored_move.name
		info_panel.move_description.text = stored_move.description
		info_panel.move_data.text = "Pow: " + str(stored_move.power) + "   Acc: " + str(stored_move.accuracy) + "%"

func _on_mouse_exited() -> void:
	if not disabled:
		info_panel.move_name.text = ""
		info_panel.move_description.text = ""
		info_panel.move_data.text = ""

func _on_pressed() -> void:
	# Set move on the current unit
	combat_manager.current_unit.current_action = combat_manager.current_unit.Action.MOVE
	combat_manager.current_unit.current_move = stored_move
	combat_manager.current_unit.set_target(combat_manager.enemy_units)
	
	# Reset move_info_panel, just in case
	info_panel.move_name.text = ""
	info_panel.move_description.text = ""
	info_panel.move_data.text = ""
	get_parent().visible = false
	
	# Call combat_manager to proceed to the next unit
	# Eventually, right now just begin combat
	combat_manager.enemy_moves()
