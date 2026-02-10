extends Node
class_name CombatManager

@export_group("Unit Lists")
var player_units : Array[PlayerUnit]
var enemy_units : Array[EnemyUnit]
var unit_list : Array[Unit]
var current_unit : PlayerUnit

@export_group("Hierarchy References")
@export var player_units_node : Node
@export var enemy_units_node : Node


# =================================================================================================


func _ready() -> void:
	combat_setup()

func combat_setup():
	# Fill player_units and set current_unit
	var temp_array = player_units_node.get_children()
	for p in temp_array:
		if p is PlayerUnit:
			player_units.append(p)
	
	current_unit = player_units[0]
	
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

func enemy_moves():
	for e in enemy_units:
		e.random_move(player_units)
	
	combat_start()

func combat_start():
	# loop through unit list, find fastest unit, make them take their turn, repeat
	for u in unit_list:
		u.take_turn()
	pass

func combat_end():
	# end of combat effects
	
	# reset combat manager
	pass
