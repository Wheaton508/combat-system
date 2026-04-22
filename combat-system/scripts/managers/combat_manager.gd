extends Node
class_name CombatManager

@onready var player_units_node: Node = $"../Units/PlayerUnits"
@onready var enemy_units_node: Node = $"../Units/EnemyUnits"
@onready var player_primary: BoardPosition = $"../Positions/PlayerPrimary"
@onready var player_secondary: BoardPosition = $"../Positions/PlayerSecondary"
@onready var player_backline: BoardPosition = $"../Positions/PlayerBackline"
@onready var enemy_primary: BoardPosition = $"../Positions/EnemyPrimary"
@onready var enemy_secondary: BoardPosition = $"../Positions/EnemySecondary"
@onready var enemy_backline: BoardPosition = $"../Positions/EnemyBackline"
@onready var ui_manager: UIManager = $"../CombatOverlay"

@export_group("Unit Lists")
var player_units : Array[PlayerUnit]
var enemy_units : Array[EnemyUnit]
var unit_list : Array[Unit]
var current_unit : PlayerUnit

var next_unit : Unit
var end_combat := false


# =================================================================================================


func _ready() -> void:
	initialize_combat()

func initialize_combat():
	# Fill player_units and set their current_positions - I want to clean this part up eventually
	var temp_array = player_units_node.get_children()
	for p in temp_array:
		if p is PlayerUnit:
			player_units.append(p)
			match p.current_position:
				Unit.Position.PRIMARY:
					player_primary.current_unit = p
				Unit.Position.SECONDARY:
					player_secondary.current_unit = p
				Unit.Position.BACKLINE:
					player_backline.current_unit = p
	
	# Fill enemy_units and set their current_positions
	temp_array = enemy_units_node.get_children()
	for e in temp_array:
		if e is EnemyUnit:
			enemy_units.append(e)
			match e.current_position:
				Unit.Position.PRIMARY:
					enemy_primary.current_unit = e
				Unit.Position.SECONDARY:
					enemy_secondary.current_unit = e
				Unit.Position.BACKLINE:
					enemy_backline.current_unit = e
	
	# Fill full units list
	for u in player_units:
		if u is Unit:
			unit_list.append(u)
	for u in enemy_units:
		if u is Unit:
			unit_list.append(u)
	
	for u in unit_list:
		u.combat_manager = self
	
	if player_primary.current_unit.incapacitated == false:
		current_unit = player_primary.current_unit
	else:
		current_unit = player_secondary.current_unit

## Sets up combat, which includes setting necessary variables for incapacitated and enemy units, as well as handling enemy move selection
func combat_setup():
	# Set has_acted for backline and incapacitated units
	for u in unit_list:
		if u.current_position == Unit.Position.BACKLINE or u.incapacitated == true:
			u.has_acted = true
	
	# Enemy move selection - only happens for units that aren't backline or incapacitated, so that they can't move after swaps or revives
	for e in enemy_units:
		if e.has_acted == false and e.incapacitated == false:
			e.select_move()
	
	combat_start()

func combat_start():
	while end_combat == false:
		next_unit = get_next_unit()
		if end_combat == false:
			next_unit.take_turn()
			await get_tree().create_timer(1).timeout
	
	combat_end()

func combat_end():
	var temp_unit : Unit
	
	for u in unit_list:
		u.reset_variables()
	
	# end of combat effects
	
	# Death check, if frontline unit is dead and backline is alive, swap them forward
	if player_primary.current_unit.incapacitated == true and player_backline.current_unit.incapacitated == false:
		temp_unit = player_primary.current_unit
		
		# Move backline unit
		player_backline.current_unit.position = player_primary.position
		player_backline.current_unit.current_position = Unit.Position.PRIMARY
		player_primary.current_unit = player_backline.current_unit
		
		# Move frontline unit
		temp_unit.position = player_backline.position
		temp_unit.current_position = Unit.Position.BACKLINE
		player_backline.current_unit = temp_unit
	elif player_secondary.current_unit.incapacitated == true and player_backline.current_unit.incapacitated == false:
		temp_unit = player_secondary.current_unit
		
		# Move backline unit
		player_backline.current_unit.position = player_secondary.position
		player_backline.current_unit.current_position = Unit.Position.SECONDARY
		player_secondary.current_unit = player_backline.current_unit
		
		# Move frontline unit
		temp_unit.position = player_backline.position
		temp_unit.current_position = Unit.Position.BACKLINE
		player_backline.current_unit = temp_unit
	
	if enemy_primary.current_unit.incapacitated == true and enemy_backline.current_unit.incapacitated == false:
		temp_unit = enemy_primary.current_unit
		
		# Move backline unit
		enemy_backline.current_unit.position = enemy_primary.position
		enemy_backline.current_unit.current_position = Unit.Position.PRIMARY
		enemy_primary.current_unit = enemy_backline.current_unit
		
		# Move frontline unit
		temp_unit.position = enemy_backline.position
		temp_unit.current_position = Unit.Position.BACKLINE
		enemy_backline.current_unit = temp_unit
		
	elif enemy_secondary.current_unit.incapacitated == true and enemy_backline.current_unit.incapacitated == false:
		temp_unit = enemy_secondary.current_unit
		
		# Move backline unit
		enemy_backline.current_unit.position = enemy_secondary.position
		enemy_backline.current_unit.current_position = Unit.Position.SECONDARY
		enemy_secondary.current_unit = enemy_backline.current_unit
		
		# Move frontline unit
		temp_unit.position = enemy_backline.position
		temp_unit.current_position = Unit.Position.BACKLINE
		enemy_backline.current_unit = temp_unit
	
	# reset combat manager
	end_combat = false
	
	if player_primary.current_unit.incapacitated == false:
		current_unit = player_primary.current_unit
	else:
		current_unit = player_secondary.current_unit
	
	ui_manager.proceed_menu("Action Select")
	ui_manager.dialogue_box.visible = false

#func get_unit_at_position(position_to_find : Unit.Position, is_player_unit : bool) -> Unit:
	#var found_unit : Unit
	#
	#match is_player_unit:
		#true:
			#for p in player_units:
				#if p.current_position == position_to_find:
					#found_unit = p
		#false:
			#for e in enemy_units:
				#if e.current_position == position_to_find:
					#found_unit = e
		#_:
			#print("ERROR. How the fuck are you seeing this? It's a boolean.")
	#
	#return found_unit

func get_next_unit() -> Unit:
	var unit : Unit
	var u_priority : int
	var unit_priority : int
	
	unit = null
	
	for u in unit_list:
		if u.has_acted == false:
			if unit == null:
				unit = u
			else:
				# Sets priority for each units based on move, or zero if swap/item
				if u.current_action == Unit.Action.SWAP or u.current_action == Unit.Action.ITEM:
					u_priority = 1
				else:
					u_priority = u.current_move.priority
				
				if unit.current_action == Unit.Action.SWAP or unit.current_action == Unit.Action.ITEM:
					unit_priority = 0
				else:
					unit_priority = unit.current_move.priority
				
				if u_priority > unit_priority:
					unit = u
				elif u_priority == unit_priority:
					var u_eff_spd := u.spd * u.spd_buff
					var unit_eff_spd := unit.spd * unit.spd_buff
					
					if u_eff_spd > unit_eff_spd:
						unit = u
					# Randomly chooses which unit to go next if speed is exactly the same
					elif u_eff_spd == unit_eff_spd:
						if randi_range(0, 1) == 0:
							unit = u
	
	if unit == null:
		end_combat = true
	
	return unit
