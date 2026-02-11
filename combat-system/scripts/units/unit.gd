extends Node3D
class_name Unit

enum Action {MOVE, ITEM, SWAP}

@export_group("Unit Stats")
@export var level := 1
@export var hit_points := 0
@export var attack := 0
@export var defense := 0
@export var magic := 0
@export var magic_defense := 0
@export var speed := 0

@export_group("Equipment")
@export var hat : Equipment
@export var top : Equipment
@export var bottoms : Equipment
@export var equipment_one : Equipment
@export var equipment_two : Equipment
@export var item : Item

@export_group("Moves")
@export var moves : Array[Move] = [null, null, null, null]

@export_group("Extra Data")
@export var role : Role

@export_group("Node References")
@export var animated_sprite : AnimatedSprite3D

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
		Action.MOVE:
			move_action(current_target, current_move)
		Action.ITEM:
			item_action()
		Action.SWAP:
			swap_action()
		_:
			print("ERROR. Ending turn.")

func move_action(target: Unit, move: Move):
	var damage_dealt : int
	
	match move.move_type:
		move.Move_Type.PHYSICAL:
			var weakness = calculate_weakness(target, move)
			damage_dealt = ((move.power * ((attack * 2) / (target.defense * weakness))) + ((level + target.level) / 2)) / 25 * randf_range(0.9, 1.1)
			if damage_dealt < 1:
				damage_dealt = 1
		move.Move_Type.MAGIC:
			var weakness = calculate_weakness(target, move)
			damage_dealt = ((move.power * ((magic * 2) / (target.magic_defense * weakness))) + ((level + target.level) / 2)) / 25 * randf_range(0.9, 1.1)
			if damage_dealt < 1:
				damage_dealt = 1
		move.Move_Type.STATUS:
			# do effect
			pass
		_:
			print("ERROR. Move failed.")
	
	animated_sprite.play("Attack01")
	print(str(name) + " attacking " + str(target.name) + " with " + str(move.name) + " for " + str(damage_dealt) + "!")

func calculate_weakness(target: Unit, move: Move) -> float:
	var weakness_mod := 1.0
	# Currently setting t = 10... what? Will need to look into this later
	for t in move.attack_types:
		print(t)
		if target.role.weaknesses.has(t):
			print(str(t) + " is a weakness of " + str(target) + ".")
		else:
			print(str(t) + " is not a weakness of " + str(target) + ".")
	# for each move type on move, if in unit.weaknesses, add one to a counter
	# if 1, 2, >=3
	# set weakness
	return weakness_mod

func item_action():
	pass

func swap_action():
	pass

func update_stats():
	# called whenever a unit levels up or (un)equips an item. likely not using this yet? but nice to have
	pass
