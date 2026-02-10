extends Node3D
class_name Unit

enum Action {ATTACK, ITEM, SWAP}

var current_hit_points : int
var effective_max_hp : int
var effective_attack : int
var effective_defense : int
var effective_magic : int
var effective_magic_defense : int
var effective_speed : int

var current_action: Action
var current_move: Move
var current_target: Unit
var has_acted := false
var incapacitated := false


# =================================================================================================


# Set "has acted" for incapacitated units at the same time as backline units in case I ever add revives
func take_turn():
	has_acted = true
	
	match current_action:
		Action.ATTACK:
			attack_action(current_target, current_move)
		Action.ITEM:
			item_action()
		Action.SWAP:
			swap_action()
		_:
			print("ERROR. Ending turn.")

func attack_action(target: Unit, move: Move):
	print(str(name) + " attacking " + str(target.name) + " with " + str(move.name) + ".")

func item_action():
	pass

func swap_action():
	pass

func update_stats():
	# called whenever a unit levels up or (un)equips an item. likely not using this yet? but nice to have
	pass
