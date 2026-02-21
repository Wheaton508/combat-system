extends Button
class_name MoveButton

# Label
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
				pass

func _on_mouse_exited() -> void:
	if not disabled:
		info_panel.move_name.text = ""
		info_panel.move_description.text = ""
		info_panel.move_data.text = ""
		
		# turn off indicators for all units
		for u in combat_manager.unit_list:
			u.indicator.visible = false

func _on_pressed() -> void:
	if stored_move.targeting_type == Move.Targeting_Type.SINGLE:
		# bring up targeting window
		pass
	elif stored_move.targeting_type == Move.Targeting_Type.ALLY:
		if combat_manager.current_unit.current_position == Unit.Position.PRIMARY:
			# target secondary
			pass
		else:
			# target primary
			pass
		pass
	else:
		# set targeting as normal
		# 
		pass
	# pull up a ui screen that has all units in combat, disable units that are not valid targets. Will have to do some weird stuff for spread moves but we will figure it out. Or it just auto selects outside of single target idk
	# also set current targets
	
	# Set move on the current unit
	#combat_manager.current_unit.current_action = combat_manager.current_unit.Action.MOVE
	#combat_manager.current_unit.current_move = stored_move
	#combat_manager.current_unit.set_target(combat_manager.enemy_units)
	
	# Reset move_info_panel, just in case - do this whenever the panel is changed
	#info_panel.move_name.text = ""
	#info_panel.move_description.text = ""
	#info_panel.move_data.text = ""
	#get_parent().visible = false
	
	# Call combat_manager to proceed to the next unit
	# Eventually, right now just begin combat
	# combat_manager.enemy_moves()
	pass
