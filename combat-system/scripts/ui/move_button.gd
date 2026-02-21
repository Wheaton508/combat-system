extends Button
class_name MoveButton

@export_group("Button Data")
@export var move_id : int

@export_group("Node References")
@export var combat_manager : CombatManager
@export var action_menu : Control
@export var target_menu : Control
@export var info_panel : MoveInfoPanel

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
	var display_power : String
	var display_accuracy : String
	
	if not disabled:
		info_panel.move_name.text = stored_move.name
		info_panel.move_description.text = stored_move.description
		
		if stored_move.power == 0:
			display_power = "-"
		else:
			display_power = str(stored_move.power)
		
		if stored_move.accuracy == 101:
			display_accuracy = "-"
		else:
			display_accuracy = str(stored_move.accuracy) + "%"
		
		info_panel.move_data.text = "Pow: " + display_power + "   Acc: " + display_accuracy
		
		match stored_move.targeting_type:
			Move.Targeting_Type.SINGLE:
				for u in combat_manager.enemy_units:
					if u.current_position == Unit.Position.PRIMARY or u.current_position == Unit.Position.SECONDARY:
						u.indicator.visible = true # add desynch if possible
			Move.Targeting_Type.SPREAD:
				for u in combat_manager.enemy_units:
					if u.current_position == Unit.Position.PRIMARY or u.current_position == Unit.Position.SECONDARY:
						u.indicator.visible = true
			Move.Targeting_Type.SELF:
				combat_manager.current_unit.indicator.visible = true
			Move.Targeting_Type.ALLY:
				var unit_ref : Unit
				
				if combat_manager.current_unit.current_position == Unit.Position.PRIMARY:
					unit_ref = combat_manager.get_unit_at_position(Unit.Position.SECONDARY, true)
				else:
					unit_ref = combat_manager.get_unit_at_position(Unit.Position.PRIMARY, true)
				
				unit_ref.indicator.visible = true
				unit_ref = null
			Move.Targeting_Type.TEAM:
				for u in combat_manager.player_units:
					if u.current_position == Unit.Position.PRIMARY or Unit.Position.SECONDARY:
						u.indicator.visible = true
			Move.Targeting_Type.FIELD:
				# turn on indicator for all other units
				pass
			_:
				print("ERROR. No valid targeting type.")

func _on_mouse_exited() -> void:
	if not disabled:
		info_panel.move_name.text = ""
		info_panel.move_description.text = ""
		info_panel.move_data.text = ""
		
		# turn off indicators for all units
		for u in combat_manager.unit_list:
			u.indicator.visible = false

func _on_pressed() -> void:
	# Set move on current_unit - HEY SO MAKE SURE YOU CAN'T TARGET INCAPACITATED GUYS THANK YOU
	# Also need to actually do the valid targeting for single moves
	combat_manager.current_unit.current_action = combat_manager.current_unit.Action.MOVE
	combat_manager.current_unit.current_move = stored_move
	
	# Set targeting for current_unit
	match stored_move.targeting_type:
		Move.Targeting_Type.SINGLE:
			target_menu.visible = true
			get_parent().visible = false
		Move.Targeting_Type.SPREAD:
			combat_manager.current_unit.current_targets.append(combat_manager.get_unit_at_position(Unit.Position.PRIMARY, false))
			combat_manager.current_unit.current_targets.append(combat_manager.get_unit_at_position(Unit.Position.SECONDARY, false))
			to_next_phase()
		Move.Targeting_Type.SELF:
			combat_manager.current_unit.current_targets.append(combat_manager.current_unit)
			to_next_phase()
		Move.Targeting_Type.ALLY:
			if combat_manager.current_unit.current_position == Unit.Position.PRIMARY:
				combat_manager.current_unit.current_targets.append(combat_manager.get_unit_at_position(Unit.Position.SECONDARY, true))
			else:
				combat_manager.current_unit.current_targets.append(combat_manager.get_unit_at_position(Unit.Position.PRIMARY, true))
			to_next_phase()
		Move.Targeting_Type.TEAM:
			combat_manager.current_unit.current_targets.append(combat_manager.get_unit_at_position(Unit.Position.PRIMARY, true))
			combat_manager.current_unit.current_targets.append(combat_manager.get_unit_at_position(Unit.Position.SECONDARY, true))
			to_next_phase()
		Move.Targeting_Type.FIELD:
			# Add enemies to targeting
			combat_manager.current_unit.current_targets.append(combat_manager.get_unit_at_position(Unit.Position.PRIMARY, false))
			combat_manager.current_unit.current_targets.append(combat_manager.get_unit_at_position(Unit.Position.SECONDARY, false))
			
			# Add ally to targeting
			if combat_manager.current_unit.current_position == Unit.Position.PRIMARY:
				combat_manager.current_unit.current_targets.append(combat_manager.get_unit_at_position(Unit.Position.SECONDARY, true))
			else:
				combat_manager.current_unit.current_targets.append(combat_manager.get_unit_at_position(Unit.Position.PRIMARY, true))
			to_next_phase()
		_:
			print("ERROR. No valid targeting type.")
	
	# Call combat_manager to proceed to the next unit
	# Eventually, right now just begin combat
	# combat_manager.enemy_moves()

func to_next_phase():
	# Resets info panel, just in case
	info_panel.move_name.text = ""
	info_panel.move_description.text = ""
	info_panel.move_data.text = ""
	
	if combat_manager.current_unit.current_position == Unit.Position.PRIMARY:
		combat_manager.current_unit = combat_manager.get_unit_at_position(Unit.Position.SECONDARY, true)
		action_menu.visible = true
		get_parent().visible = false
	else:
		combat_manager.combat_setup()
		get_parent().visible = false
		pass
	
	
