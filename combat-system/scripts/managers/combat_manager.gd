extends Node
class_name CombatManager

@export_group("Hierarchy References")
@export var player_units_node : Node
@export var enemy_units_node : Node

@export_group("Unit Lists")
var player_units : Array[PlayerUnit]
var enemy_units : Array[EnemyUnit]
var unit_list : Array[Unit]
var current_unit : PlayerUnit


# =================================================================================================


func _ready() -> void:
	combat_setup()

func combat_setup():
	# Fill player_units and set current_unit
	var temp_array = player_units_node.get_children()
	for p in temp_array:
		if p is PlayerUnit:
			player_units.append(p)
	
	# Fill enemy_units
	temp_array = enemy_units_node.get_children()
	for e in temp_array:
		if e is EnemyUnit:
			enemy_units.append(e)
	
	# Fill full units list
	for u in player_units:
		if u is Unit:
			unit_list.append(u)
	for u in enemy_units:
		if u is Unit:
			unit_list.append(u)
	
	current_unit = get_unit_at_position(Unit.Position.PRIMARY, true)

func enemy_moves():
	for e in enemy_units:
		e.random_move(player_units)
	
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
