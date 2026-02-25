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

@export_group("Unit Lists")
var player_units : Array[PlayerUnit]
var enemy_units : Array[EnemyUnit]
var unit_list : Array[Unit]
var current_unit : PlayerUnit


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
	
	if get_unit_at_position(Unit.Position.PRIMARY, true).incapacitated == false:
		current_unit = get_unit_at_position(Unit.Position.PRIMARY, true)
	else:
		current_unit = get_unit_at_position(Unit.Position.SECONDARY, true)

## Sets up combat, which includes setting necessary variables for incapacitated and enemy units, as well as handling enemy move selection
func combat_setup():
	# Set has_acted for backline and incapacitated units
	for u in unit_list:
		if u.current_position == Unit.Position.BACKLINE or u.incapacitated == true:
			u.has_acted = true
	
	# Enemy move selection - only happens for units that aren't backline or incapacitated, so that they can't move after swaps or revives
	for e in enemy_units:
		if e.has_acted != true:
			e.select_move()
	
	combat_start()

func combat_start():
	# loop through unit list, find fastest unit, make them take their turn, repeat
	for u in unit_list:
		u.take_turn()
	
	combat_end()

func combat_end():
	for u in unit_list:
		u.has_acted = false
		u.protecting = false
		u.current_targets.clear()
	# end of combat effects
	
	# reset combat manager
	pass

func get_unit_at_position(position_to_find : Unit.Position, is_player_unit : bool) -> Unit:
	var found_unit : Unit
	
	match is_player_unit:
		true:
			for p in player_units:
				if p.current_position == position_to_find:
					found_unit = p
		false:
			for e in enemy_units:
				if e.current_position == position_to_find:
					found_unit = e
		_:
			print("ERROR. How the fuck are you seeing this? It's a boolean.")
	
	return found_unit
